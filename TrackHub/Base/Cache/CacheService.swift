//
//  CacheService.swift
//  TrackHub
//
//  Created by Sanjay Soni on 16/08/23.
//

import Cache
import Foundation

protocol CacheService {
    func setAuthUser(user: User) throws
    func getAuthUser() throws -> User

    func setFollowers(followers users: [BasicUser]) throws
    func getFollowers() throws -> [BasicUser]

    func setFollowings(followings users: [BasicUser]) throws
    func getFollowings() throws -> [BasicUser]

    func setInsightsData(_ users: [BasicUser], for type: UsersType) throws
    func getInsightsData(for type: UsersType) throws -> [BasicUser]

    func resetUsers() throws
    func resetAll() throws
}

enum CacheError: LocalizedError {
    case noRecordFound
}

final class CacheServiceImp: CacheService {
    private enum Keys: String {
        case authUser
        case followers
        case followings
    }

    private let usersDiskConfig = DiskConfig(name: "Users")
    private let insightsDiskConfig = DiskConfig(name: "Insights")

    private var authUserStorage: DiskStorage<String, User>? {
        let storage = try? DiskStorage<String, User>(
            config: usersDiskConfig,
            transformer: TransformerFactory.forCodable(ofType: User.self)
        )
        return storage
    }

    private var usersStorage: DiskStorage<String, [BasicUser]>? {
        let storage = try? DiskStorage<String, [BasicUser]>(
            config: usersDiskConfig,
            transformer: TransformerFactory.forCodable(ofType: [BasicUser].self)
        )
        return storage
    }

    private var insightsStorage: DiskStorage<String, [BasicUser]>? {
        let storage = try? DiskStorage<String, [BasicUser]>(
            config: insightsDiskConfig,
            transformer: TransformerFactory.forCodable(ofType: [BasicUser].self)
        )
        return storage
    }

    func setAuthUser(user: User) throws {
        try authUserStorage?.setObject(user, forKey: Keys.authUser.rawValue)
    }

    func getAuthUser() throws -> User {
        guard let user = try authUserStorage?.object(forKey: Keys.authUser.rawValue) else {
            throw CacheError.noRecordFound
        }
        return user
    }

    func setFollowers(followers users: [BasicUser]) throws {
        try usersStorage?.setObject(users, forKey: Keys.followers.rawValue)
    }

    func getFollowers() throws -> [BasicUser] {
        guard let followers = try usersStorage?.object(forKey: Keys.followers.rawValue) else {
            throw CacheError.noRecordFound
        }
        return followers
    }

    func setFollowings(followings users: [BasicUser]) throws {
        try usersStorage?.setObject(users, forKey: Keys.followings.rawValue)
    }

    func getFollowings() throws -> [BasicUser] {
        guard let followings = try usersStorage?.object(forKey: Keys.followings.rawValue) else {
            throw CacheError.noRecordFound
        }
        return followings
    }

    func setInsightsData(_ users: [BasicUser], for type: UsersType) throws {
        try insightsStorage?.setObject(users, forKey: type.rawValue)
    }

    func getInsightsData(for type: UsersType) throws -> [BasicUser] {
        guard let users = try insightsStorage?.object(forKey: type.rawValue) else {
            throw CacheError.noRecordFound
        }
        return users
    }

    func resetUsers() throws {
        try authUserStorage?.removeAll()
        try usersStorage?.removeAll()
    }

    func resetAll() throws {
        try resetUsers()
        try insightsStorage?.removeAll()
    }
}
