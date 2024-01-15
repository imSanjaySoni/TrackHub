//
//  AuthService.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import FirebaseAuth
import Foundation

protocol AuthService {
    func signIn() async throws
    func signOut() throws
    func getAuthToken() -> String?
}

final class AuthServiceImp: AuthService {
    private let userDefaultService: UserDefaultsService

    init(userDefaultService: UserDefaultsService) {
        self.userDefaultService = userDefaultService
    }

    func getAuthToken() -> String? {
        userDefaultService.getAuthToken()
    }

    func signIn() async throws {
        do {
            let authToken = try await loginWithGitHub()

            guard let authToken else {
                throw AuthError.unknown
            }

            // Store AuthToken to UserDefaults
            userDefaultService.setAuthToken(token: authToken)
        } catch {
            throw AuthError.unknown
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
        userDefaultService.reset()
    }

    private func loginWithGitHub() async throws -> String? {
        /// Setup GitHub OAuth provider
        let provider = OAuthProvider(providerID: "github.com")

        /*
         Set scope for GitHub APIs
         User: Grants read/write access to profile info only. Note that this scope includes user:email and user:follow.
            read:user   ->  Grants access to read a user's profile data.
            user:email  ->  Grants read access to a user's email addresses.
            user:follow ->  Grants access to follow or unfollow other users.
         */
        provider.scopes = ["user"]

        /// Disable GitHub signup option
        provider.customParameters = ["allow_signup": "false"]

        let credential = try await provider.credential(with: nil)

        let authResult = try await Auth.auth().signIn(with: credential)

        guard let oAuthCredential = authResult.credential as? OAuthCredential else {
            return nil
        }

        return oAuthCredential.accessToken
    }
}
