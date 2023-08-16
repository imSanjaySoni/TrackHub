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

    private let diskConfig = DiskConfig(name: "Users")

    private var authUserStorage: DiskStorage<String, User>? {
        let storage = try? DiskStorage<String, User>(
            config: diskConfig,
            transformer: TransformerFactory.forCodable(ofType: User.self)
        )
        return storage
    }

    private var usersStorage: DiskStorage<String, [BasicUser]>? {
        let storage = try? DiskStorage<String, [BasicUser]>(
            config: diskConfig,
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
}
