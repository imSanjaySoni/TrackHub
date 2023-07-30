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
    // MARK: Internal

    func signIn() async throws {
        do {
            let authToken = try await loginWithGitHub()

            guard let authToken else {
                return
            }

            // Store AuthToken to UserDefaults
            cacheAuthToken(authToken)
        } catch {
            throw AuthError.unknown
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: Keys.AuthToken.rawValue)
    }

    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: Keys.AuthToken.rawValue)
    }

    // MARK: Private

    private func cacheAuthToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: Keys.AuthToken.rawValue)
    }

    private func loginWithGitHub() async throws -> String? {
        // Setup GitHub OAuth provider
        let provider = OAuthProvider(providerID: "github.com")
        provider.customParameters = ["allow_signup": "false"]
        provider.scopes = ["user"]

        let credential = try await provider.credential(with: nil)

        let authResult = try await Auth.auth().signIn(with: credential)

        guard let oAuthCredential = authResult.credential as? OAuthCredential else {
            return nil
        }

        return oAuthCredential.accessToken
    }
}
