//
//  UsersService.swift
//  TrackHub
//
//  Created by Sanjay Soni on 10/08/23.
//

import Foundation

protocol UsersService {
    func getCurrentUser() async throws -> User
    func getUserProfile(with username: String) async throws -> User

    func getFollowers() async throws -> [BasicUser]
    func getFollowing() async throws -> [BasicUser]

    func followUser(with username: String) async throws
    func unfollowUser(with username: String) async throws
}

final class UsersServiceImp: UsersService {
    // MARK: Lifecycle

    init(apiClient: GithubApiClient, cacheService: CacheService) {
        self.client = apiClient
        self.cacheService = cacheService
    }

    // MARK: Internal

    private let client: GithubApiClient
    private let cacheService: CacheService

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

    func getFollowers() async throws -> [BasicUser] {
        guard let cachedFollowers = try? cacheService.getFollowers() else {
            return try await fetchAndCacheUsers(ofType: .Followers)
        }
        return cachedFollowers
    }

    func getFollowing() async throws -> [BasicUser] {
        guard let cachedFollowings = try? cacheService.getFollowings() else {
            return try await fetchAndCacheUsers(ofType: .Following)
        }
        return cachedFollowings
    }

    func followUser(with username: String) async throws {
        try await client.followUser(username)
    }

    func unfollowUser(with username: String) async throws {
        try await client.unfollowUser(username)
    }

    private func fetchAndCacheUsers(ofType type: UsersType) async throws -> [BasicUser] {
        let isForFollowers: Bool = type == .Followers

        guard let totalUsers = try? isForFollowers ? cacheService.getAuthUser().followers : cacheService.getAuthUser().following else {
            return []
        }

        var pageCount = 0
        var users = [BasicUser]()

        for _ in stride(from: 0, to: totalUsers, by: 100) {
            pageCount += 1

            let fetchedUsers = try await isForFollowers ? client.fetchFollowers(from: pageCount) : client.fetchFollowing(from: pageCount)

            users.append(contentsOf: fetchedUsers)
        }

        try isForFollowers ? cacheService.setFollowers(followers: users) : cacheService.setFollowings(followings: users)

        return users
    }
}
