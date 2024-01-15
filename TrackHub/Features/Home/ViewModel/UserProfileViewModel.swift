//
//  UserProfileViewModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 12/08/23.
//

import Foundation

@MainActor
final class UserProfileViewModel: ObservableObject {
    private let usersService: UsersService
    private let username: String
    private let isUserFollowsMe: Bool

    @Published private(set) var user: RequestPhase<User> = .idle
    @Published private(set) var isFollowing: Bool
    @Published private(set) var relation: UserRelationType

    init(usersService: UsersService, username: String, relation: UserRelationType?) {
        self.usersService = usersService
        self.username = username
        self.relation = relation ?? .noRelation

        self.isUserFollowsMe = relation == .mutual || relation == .follower

        self.isFollowing = {
            guard let relation else {
                return false
            }

            return switch relation {
            case .follower,
                 .noRelation:
                false
            case .following,
                 .mutual:
                true
            }
        }()
    }

    func loadProfile() {
        Task {
            user = .loading
            do {
                let data = try await usersService.getUserProfile(with: username)
                user = .data(data.updateRelation(with: .mutual))
            } catch {
                user = .error(error.localizedDescription)
            }
        }
    }

    func followOrUnfollow() {
        Task {
            guard let unwrappedData = user.unwrappedData else {
                return
            }

            do {
                if isFollowing {
                    isFollowing = false
                    relation = isUserFollowsMe ? .follower : .noRelation
                    user = .data(unwrappedData.copyWith(followers: unwrappedData.followers - 1))

                    try await usersService.unfollowUser(with: username)
                } else {
                    isFollowing = true
                    relation = isUserFollowsMe ? .mutual : .following
                    user = .data(unwrappedData.copyWith(followers: unwrappedData.followers + 1))

                    try await usersService.followUser(with: username)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
