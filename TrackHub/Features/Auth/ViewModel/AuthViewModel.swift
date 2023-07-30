//
//  AuthViewModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 29/07/23.
//

import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    private let service: AuthService

    @Published private(set) var requestState = RequestState<Bool>.idle

    init(service: AuthService) {
        self.service = service
    }

    func login() {
        Task {
            do {
                self.requestState = .loading
                try await service.login()
                self.requestState = .data(true)
            } catch {
                self.requestState = .error(error.localizedDescription)
            }
        }
    }
}
