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

    init(apiClient: GithubApiClient) {
        self.client = apiClient
    }

    // MARK: Internal

    let client: GithubApiClient

    func getCurrentUser() async throws -> User {
        return try await client.fetchCurrentUser()
    }

    func getUserProfile(with username: String) async throws -> User {
        return try await client.fetchUserProfile(username)
    }

    func getFollowers() async throws -> [BasicUser] {
        return try await client.fetchFollowers(after: nil)
    }

    func getFollowing() async throws -> [BasicUser] {
        return try await client.fetchFollowing(after: nil)
    }

    func followUser(with username: String) async throws {
        try await client.followUser(username)
    }

    func unfollowUser(with username: String) async throws {
        try await client.unfollowUser(username)
    }
}
