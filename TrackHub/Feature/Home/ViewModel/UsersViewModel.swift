//
//  UsersViewModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 10/08/23.
//

import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
    // MARK: Lifecycle

    init(_ userService: UsersService) {
        self.service = userService
    }

    // MARK: Internal

    @Published private(set) var users: RequestPhase<[BasicUser]> = .idle

    func loadUsers(for usersType: UsersType) {
        Task {
            users = .loading

            do {
                let data = try await usersType == .Followers ?
                    service.getFollowers() :
                    service.getFollowing()

                users = .data(data)
            } catch {
                users = .error(error.localizedDescription)
            }
        }
    }

    func followOrUnfollowUser(with username: String, for follow: Bool) {
        Task {
            try? await follow ?
                service.followUser(with: username) :
                service.unfollowUser(with: username)
        }
    }

    // MARK: Private

    private let service: UsersService
}
