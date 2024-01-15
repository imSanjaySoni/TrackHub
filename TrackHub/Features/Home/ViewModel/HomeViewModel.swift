//
//  HomeViewModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 12/08/23.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    private let usersService: UsersService

    @Published private(set) var phase: RequestPhase<HomeScreenDataModel> = .idle

    init(usersService: UsersService) {
        self.usersService = usersService
        loadScreen()
    }

    private func loadScreen() {
        Task {
            phase = .loading
            do {
                let data = try await usersService.initializeApp()
                phase = .data(data)
            } catch {
                phase = .error(error.localizedDescription)
            }
        }
    }

    func refresh() async {
        do {
            let refreshedData = try await usersService.refresh()
            phase = .data(refreshedData)
        } catch {
            print(error.localizedDescription)
        }
    }
}
