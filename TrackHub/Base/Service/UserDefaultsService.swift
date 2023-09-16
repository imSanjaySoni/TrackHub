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

    func getAppearanceType() -> AppearanceType?
    func setAppearanceType(appearance: AppearanceType)

    func getNotificationStatus() -> Bool?
    func setNotificationStatus(status: Bool)
    func getNotificationTriggerTime() -> Date?
    func setNotificationTriggerTime(time: Date)

    func reset()
}

final class UserDefaultsServiceImp: UserDefaultsService {
    private let defaults = UserDefaults.standard

    private enum Keys: String, CaseIterable {
        case AuthToken
        case Appearance
        case NotificationStatus
        case NotificationTime
    }

    func getAppearanceType() -> AppearanceType? {
        defaults.getObject(forKey: Keys.Appearance.rawValue)
    }

    func setAppearanceType(appearance: AppearanceType) {
        defaults.setObject(appearance, forKey: Keys.Appearance.rawValue)
    }

    func setAuthToken(token: String) {
        defaults.setValue(token, forKey: Keys.AuthToken.rawValue)
    }

    func getAuthToken() -> String? {
        defaults.string(forKey: Keys.AuthToken.rawValue)
    }

    func getNotificationStatus() -> Bool? {
        defaults.bool(forKey: Keys.NotificationStatus.rawValue)
    }

    func setNotificationStatus(status: Bool) {
        defaults.set(status, forKey: Keys.NotificationStatus.rawValue)
    }

    func getNotificationTriggerTime() -> Date? {
        defaults.object(forKey: Keys.NotificationTime.rawValue) as? Date
    }

    func setNotificationTriggerTime(time: Date) {
        defaults.set(time, forKey: Keys.NotificationTime.rawValue)
    }

    func reset() {
        Keys.allCases.forEach { defaults.removeObject(forKey: $0.rawValue) }
    }
}
