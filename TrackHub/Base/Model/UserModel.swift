//
//  UserModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 30/07/23.
//

import Foundation

enum RelationType {
    case mutual
    case follower
    case following

    // MARK: Internal

    var label: String {
        switch self {
        case .mutual:
            return "You are following each other"
        case .follower:
            return "Follows you"
        case .following:
            return "You follow"
        }
    }

    var icon: String {
        switch self {
        case .mutual:
            return Assets.Bold.mutual
        case .follower:
            return Assets.Bold.follower
        case .following:
            return Assets.Bold.following
        }
    }
}

struct User: Codable, Identifiable {
    // MARK: Internal

    let id: Int
    let name: String?
    let bio: String?
    let company: String?
    let username: String
    let location: String?
    let email: String?
    let avatarUrl: String
    let followers: Int
    let following: Int
    let profileUrl: String
    private(set) var relation: RelationType?

    func updateRelation(with relation: RelationType) -> User {
        User(
            id: self.id,
            name: self.name,
            bio: self.bio,
            company: self.company,
            username: self.username,
            location: self.location,
            email: self.email,
            avatarUrl: self.avatarUrl,
            followers: self.followers,
            following: self.following,
            profileUrl: self.profileUrl,
            relation: relation
        )
    }

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case bio
        case company
        case location
        case followers
        case following
        case email
        case username = "login"
        case avatarUrl = "avatar_url"
        case profileUrl = "html_url"
    }
}

struct BasicUser: Codable, Identifiable {
    // MARK: Internal

    let id: Int
    let username: String
    let avatarUrl: String
    private(set) var relation: RelationType?

    func updateRelation(with relation: RelationType) -> BasicUser {
        BasicUser(
            id: self.id,
            username: self.username,
            avatarUrl: self.avatarUrl,
            relation: relation
        )
    }

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case avatarUrl = "avatar_url"
    }
}

extension User {
    static let mock = User(
        id: 1,
        name: "Sanjay Soni",
        bio: "Mobile Developer | Flutter | SwiftUI",
        company: "Mobile Developer at Uni Cards",
        username: "imSanjaySoni",
        location: "Bangalore India",
        email: "imsanjaysoni@outlook.com",
        avatarUrl: "https://avatars.githubusercontent.com/u/20748185?v=4",
        followers: 222,
        following: 12,
        profileUrl: "https://github.com/imSanjaySoni",
        relation: .follower
    )
}

extension BasicUser {
    static let mock = BasicUser(
        id: 1,
        username: "imSanjaySoni",
        avatarUrl: "https://avatars.githubusercontent.com/u/20748185?v=4",
        relation: .following
    )
}
