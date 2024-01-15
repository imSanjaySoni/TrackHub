//
//  UserModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 30/07/23.
//

import Foundation

enum UserRelationType: String, Codable {
    case mutual
    case follower
    case following
    case noRelation
}

struct User: Codable, Identifiable {
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
    let relation: UserRelationType?

    func updateRelation(with relation: UserRelationType) -> User {
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

    func copyWith(
        id: Int? = nil,
        name: String? = nil,
        bio: String? = nil,
        company: String? = nil,
        username: String? = nil,
        location: String? = nil,
        email: String? = nil,
        avatarUrl: String? = nil,
        followers: Int? = nil,
        following: Int? = nil,
        profileUrl: String? = nil,
        relation: UserRelationType? = nil
    ) -> User {
        User(
            id: id ?? self.id,
            name: name ?? self.name,
            bio: bio ?? self.bio,
            company: company ?? self.company,
            username: username ?? self.username,
            location: location ?? self.location,
            email: email ?? self.email,
            avatarUrl: avatarUrl ?? self.avatarUrl,
            followers: followers ?? self.followers,
            following: following ?? self.following,
            profileUrl: profileUrl ?? self.profileUrl,
            relation: relation ?? self.relation
        )
    }

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
        case relation
    }
}

struct BasicUser: Codable, Identifiable, Hashable, Equatable {
    let id: Int
    let username: String
    let avatarUrl: String
    let relation: UserRelationType?

    func updateRelation(with relation: UserRelationType) -> BasicUser {
        BasicUser(
            id: self.id,
            username: self.username,
            avatarUrl: self.avatarUrl,
            relation: relation
        )
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case avatarUrl = "avatar_url"
        case relation
    }

    static func == (lhs: BasicUser, rhs: BasicUser) -> Bool {
        lhs.username == rhs.username && lhs.id == rhs.id
    }
}

enum UsersType: String {
    case following
    case followers
    case mutual
    case newFollowers
    case lostFollowers
    case unfollowed
    case notFollowingMeBack
    case iAmNotFollowingBack
}

extension UserRelationType {
    var label: String {
        switch self {
        case .mutual:
            return "You are following each other"
        case .follower:
            return "Follows you"
        case .following:
            return "You follow"
        case .noRelation:
            return "No relation"
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
        case .noRelation:
            return Assets.Bold.noRelation
        }
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
