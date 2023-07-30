//
//  AuthService.swift
//  TrackHub
//
//  Created by Sanjay Soni on 29/07/23.
//

import FirebaseAuth
import Foundation

protocol AuthService {
    func login() async throws
    func signOut() async throws
}

final class AuthServiceImp: AuthService {
    private let userDefaults = UserDefaults.standard

    func login() async throws {
        let token = try await loginWithGithub()

        if let token {
            userDefaults.set(token, forKey: Keys.AuthToken.rawValue)
        }
    }

    func signOut() async throws {
        try? Auth.auth().signOut()
        userDefaults.removeObject(forKey: Keys.AuthToken.rawValue)
    }

    private func loginWithGithub() async throws -> String? {
        let provider = OAuthProvider(providerID: "github.com")

        /*
         Set scope for GitHub APIs
         User: Grants read/write access to profile info only. Note that this scope includes user:email and user:follow.
            read:user   ->  Grants access to read a user's profile data.
            user:email  ->  Grants read access to a user's email addresses.
            user:follow ->  Grants access to follow or unfollow other users.
         */
        provider.scopes = ["user"]

        // Disable GitHub signup option
        provider.customParameters = ["allow_signup": "false"]

        do {
            let credential = try await provider.credential(with: nil)
            let authDataResult = try await Auth.auth().signIn(with: credential)

            guard let oAuthCredential = authDataResult.credential as? OAuthCredential else {
                return nil
            }

            guard let token = oAuthCredential.accessToken else {
                return nil
            }

            return token

        } catch {
            print("There was an issue when trying to sign in: \(error)")
            throw ApiError.unimplemented
        }
    }
}
