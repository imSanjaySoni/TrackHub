//
//  UsersViewModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 10/08/23.
//

import Combine
import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
    private let service: UsersService

    @Published private(set) var users: RequestPhase<[BasicUser]> = .idle
    @Published var searchQuery = ""

    private var savedUsers = [BasicUser]()
    private var cancellable = Set<AnyCancellable>()

    init(usersService: UsersService) {
        self.service = usersService
        listenSearchQuery()
    }

    private func listenSearchQuery() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] query in
                guard let self else {
                    return
                }
                self.search(query: query)
            })
            .store(in: &cancellable)
    }

    private func search(query: String) {
        switch users {
        case .error,
             .idle,
             .loading: return

        case .data,
             .empty:
            if query.isEmpty {
                users = .data(savedUsers)
                return
            }

            let filteredUsers = savedUsers.filter { $0.username.localizedCaseInsensitiveContains(query) }

            if filteredUsers.isEmpty {
                users = .empty
                return
            }
            users = .data(filteredUsers)
        }
    }

    func loadUsers(for type: UsersType) {
        Task {
            users = .loading
            do {
                let data = try await service.getUsers(for: type)
                users = data.isEmpty ? .empty : .data(data)
                savedUsers = data
            } catch {
                users = .error(error.localizedDescription)
            }
        }
    }

    func followOrUnfollowUser(with username: String, for follow: Bool) {
        Task {
            try? await follow ? service.followUser(with: username) : service.unfollowUser(with: username)
        }
    }
}
