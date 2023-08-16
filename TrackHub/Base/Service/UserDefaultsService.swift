//
//  UserDefaultsService.swift
//  TrackHub
//
//  Created by Sanjay Soni on 15/08/23.
//

import Foundation

protocol UserDefaultsService {
    func setAuthToken(token: String)
    func getAuthToken() -> String?

    func reset()
}

final class UserDefaultsServiceImp: UserDefaultsService {
    // MARK: Internal

    func setAuthToken(token: String) {
        defaults.setValue(token, forKey: Keys.AuthToken.rawValue)
    }

    func getAuthToken() -> String? {
        defaults.string(forKey: Keys.AuthToken.rawValue)
    }

    func reset() {
        Keys.allCases.forEach { defaults.removeObject(forKey: $0.rawValue) }
    }

    // MARK: Private

    private enum Keys: String, CaseIterable {
        case AuthToken
    }

    private let defaults = UserDefaults.standard
}
