//
//  UsersTypeModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 18/09/23.
//

import Foundation

extension UsersType {
    var title: String {
        switch self {
        case .followers:
            "Followers"
        case .following:
            "Following"
        case .mutual:
            "Mutual Following"
        case .newFollowers:
            "New Followers"
        case .lostFollowers:
            "Follower Lost"
        case .notFollowingMeBack:
            "Not Following Me Back"
        case .iAmNotFollowingBack:
            "I'm Not Following Back"
        case .unfollowed:
            "Users I've Unfollowed"
        }
    }

    var image: String {
        switch self {
        case .followers:
            Assets.gitHub
        case .following:
            Assets.gitHub
        case .mutual:
            Assets.Bold.mutual
        case .newFollowers:
            Assets.gitHub
        case .lostFollowers:
            Assets.gitHub
        case .notFollowingMeBack:
            Assets.Bold.following
        case .iAmNotFollowingBack:
            Assets.Bold.follower
        case .unfollowed:
            Assets.gitHub
        }
    }
}
