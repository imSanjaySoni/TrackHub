//
//  UsersService.swift
//  TrackHub
//
//  Created by Sanjay Soni on 10/08/23.
//

import Foundation

protocol UsersService {
    func initializeApp() async throws -> HomeScreenDataModel
    func refresh() async throws -> HomeScreenDataModel

    func getCurrentUser() async throws -> User
    func getUserProfile(with username: String) async throws -> User

    func getUsers(for type: UsersType) async throws -> [BasicUser]

    func followUser(with username: String) async throws
    func unfollowUser(with username: String) async throws
}

final class UsersServiceImp: UsersService {
    private let client: GithubApiClient
    private let cacheService: CacheService

    init(apiClient: GithubApiClient, cacheService: CacheService) {
        self.client = apiClient
        self.cacheService = cacheService
    }

    private enum Error: LocalizedError {
        case unauthorised
        case somethingWentWrong
    }

    func initializeApp() async throws -> HomeScreenDataModel {
        guard let currentUser = try? await getCurrentUser() else {
            throw Error.unauthorised
        }

        guard let followers = try? await getFollowers() else {
            throw Error.somethingWentWrong
        }

        guard let following = try? await getFollowing() else {
            throw Error.somethingWentWrong
        }

        let followersSet = Set(followers.data)
        let followingSet = Set(following.data)

        let mutuals = try getAndCacheInsightData(for: .mutual) {
            followersSet.intersection(followingSet).map { $0.updateRelation(with: .mutual) }
        }

        let iAmNotFollowing = try getAndCacheInsightData(for: .iAmNotFollowingBack) {
            followersSet.subtracting(followingSet).map { $0.updateRelation(with: .follower) }
        }

        let notFollowingMe = try getAndCacheInsightData(for: .notFollowingMeBack) {
            followingSet.subtracting(followersSet).map { $0.updateRelation(with: .following) }
        }

        if !followers.isFromCached {
            let withUpdatedRelation = followers.data.map { follower in
                follower.updateRelation(with: mutuals.contains(where: { $0.username == follower.username }) ? .mutual : .follower)
            }
            try cacheService.setFollowers(followers: withUpdatedRelation)
            try cacheService.setInsightsData(withUpdatedRelation, for: .followers)
        }

        if !following.isFromCached {
            let withUpdatedRelation = following.data.map { following in
                following.updateRelation(with: mutuals.contains(where: { $0.username == following.username }) ? .mutual : .following)
            }
            try cacheService.setFollowings(followings: withUpdatedRelation)
            try cacheService.setInsightsData(withUpdatedRelation, for: .following)
        }

        guard let oldFollowers = try? cacheService.getInsightsData(for: .followers) else {
            throw Error.somethingWentWrong
        }

        guard let oldFollowing = try? cacheService.getInsightsData(for: .following) else {
            throw Error.somethingWentWrong
        }

        let oldFollowersSet = Set(oldFollowers)
        let oldFollowingSet = Set(oldFollowing)

        let newFollowers = try getAndCacheInsightData(for: .newFollowers) {
            Array(oldFollowersSet.subtracting(followersSet))
        }

        let lostFollowers = try getAndCacheInsightData(for: .lostFollowers) {
            Array(followersSet.subtracting(oldFollowersSet))
        }

        let unfollowed = try getAndCacheInsightData(for: .unfollowed) {
            Array(followingSet.subtracting(oldFollowingSet))
        }

        return HomeScreenDataModel(
            user: currentUser,
            newFollowersCount: newFollowers.count,
            lostFollowersCount: lostFollowers.count,
            mutualsCount: mutuals.count,
            notFollowingCount: iAmNotFollowing.count,
            notFollowingMeBackCount: notFollowingMe.count,
            unfollowedCount: unfollowed.count)
    }

    func refresh() async throws -> HomeScreenDataModel {
        try cacheService.resetUsers()
        return try await initializeApp()
    }

    func getCurrentUser() async throws -> User {
        guard let cacheUser = try? cacheService.getAuthUser() else {
            let fetchedUser = try await client.fetchCurrentUser()
            try cacheService.setAuthUser(user: fetchedUser)
            return fetchedUser
        }
        return cacheUser
    }

    func getUserProfile(with username: String) async throws -> User {
        return try await client.fetchUserProfile(username)
    }

    func followUser(with username: String) async throws {
        try await client.followUser(username)
    }

    func unfollowUser(with username: String) async throws {
        try await client.unfollowUser(username)
    }

    private func getFollowers() async throws -> (data: [BasicUser], isFromCached: Bool) {
        guard let cachedFollowers = try? cacheService.getFollowers() else {
            let fetchedFollowers = try await fetchUsers(ofType: .followers)
            return (data: fetchedFollowers, isFromCached: false)
        }
        return (data: cachedFollowers, isFromCached: true)
    }

    private func getFollowing() async throws -> (data: [BasicUser], isFromCached: Bool) {
        guard let cachedFollowings = try? cacheService.getFollowings() else {
            let fetchedFollowings = try await fetchUsers(ofType: .following)
            return (data: fetchedFollowings, isFromCached: false)
        }
        return (data: cachedFollowings, isFromCached: true)
    }

    func getUsers(for type: UsersType) async throws -> [BasicUser] {
        switch type {
        case .following:
            try cacheService.getFollowings()
        case .followers:
            try cacheService.getFollowers()
        case .iAmNotFollowingBack,
             .lostFollowers,
             .mutual,
             .newFollowers,
             .notFollowingMeBack,
             .unfollowed:
            try cacheService.getInsightsData(for: type)
        }
    }

    private func getAndCacheInsightData(for type: UsersType, where compute: () -> [BasicUser]) throws -> [BasicUser] {
        guard let cachedData = try? cacheService.getInsightsData(for: type) else {
            let newData = compute()
            try cacheService.setInsightsData(newData, for: type)
            return newData
        }
        return cachedData
    }

    private func fetchUsers(ofType type: UsersType) async throws -> [BasicUser] {
        let isForFollowers: Bool = type == .followers

        guard let totalUsers = try? isForFollowers ? cacheService.getAuthUser().followers : cacheService.getAuthUser().following else {
            return []
        }

        var pageCount = 0
        var users = [BasicUser]()

        for _ in stride(from: 0, to: totalUsers, by: Values.perPageCount) {
            pageCount += 1

            let fetchedUsers = try await isForFollowers ? client.fetchFollowers(from: pageCount) : client.fetchFollowing(from: pageCount)

            users.append(contentsOf: fetchedUsers)
        }
        return users
    }
}
