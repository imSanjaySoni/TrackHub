//
//  AuthViewModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    private let auth: AuthService

    init(authService: AuthService) {
        auth = authService
        isAuthenticated = auth.getAuthToken() != nil
    }

    @Published private(set) var authPhase: AuthPhase = .idle
    @Published private(set) var isAuthenticated: Bool

    func signInWithGithub() {
        Task {
            authPhase = .loading
            do {
                try await auth.signIn()
                authPhase = .success
                isAuthenticated = true
            } catch {
                authPhase = .fail
            }
        }
    }

    func signOut() {
        do {
            try auth.signOut()
            isAuthenticated = false
            authPhase = .idle
        } catch {
            print(error.localizedDescription)
        }
    }
}
