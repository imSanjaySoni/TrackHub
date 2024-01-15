//
//  SettingsViewModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 17/08/23.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    private let cacheService: CacheService
    private let userDefaultService: UserDefaultsService

//    @Published var scheduleTime: Date
//    @Published var shouldScheduleNotification: Bool

    @Published private(set) var appearance: AppearanceType

    init(cache cacheService: CacheService, userDefaults usersDefaultsService: UserDefaultsService) {
        self.cacheService = cacheService
        self.userDefaultService = usersDefaultsService

//        self.scheduleTime = usersDefaultsService.getNotificationTriggerTime() ?? .now
//        self.shouldScheduleNotification = usersDefaultsService.getNotificationStatus() ?? true

        self.appearance = userDefaultService.getAppearanceType() ?? .automatic
    }

    func changeAppearance(with appearance: AppearanceType) {
        withAnimation {
            self.appearance = appearance
            userDefaultService.setAppearanceType(appearance: appearance)
        }
    }

    func clearCache() {
        try? cacheService.resetAll()
    }
}
