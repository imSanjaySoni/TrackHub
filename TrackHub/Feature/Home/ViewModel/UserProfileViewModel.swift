//
//  UserProfileViewModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 12/08/23.
//

import Foundation

@MainActor
final class UserProfileViewModel: ObservableObject {
    // MARK: Lifecycle

    init(usersService: UsersService) {
        self.usersService = usersService
    }

    // MARK: Internal

    @Published private(set) var user: RequestPhase<User> = .idle

    func loadProfile(for username: String) {
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

    // MARK: Private

    private let usersService: UsersService
}
