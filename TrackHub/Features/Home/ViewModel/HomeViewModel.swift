//
//  HomeViewModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 12/08/23.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    // MARK: Lifecycle

    init(usersService: UsersService) {
        self.usersService = usersService
        loadCurrentUser()
    }

    // MARK: Internal

    @Published private(set) var user: RequestPhase<User> = .idle

    // MARK: Private

    private let usersService: UsersService

    private func loadCurrentUser() {
        Task {
            user = .loading
            do {
                let data = try await usersService.getCurrentUser()
                user = .data(data)
            } catch {
                user = .error(error.localizedDescription)
            }
        }
    }
}
