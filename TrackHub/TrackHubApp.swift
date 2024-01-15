//
//  TrackHubApp.swift
//  TrackHub
//
//  Created by Sanjay Soni on 31/07/23.
//

import FirebaseCore
import SwiftUI

@main
struct TrackHubApp: App {
    init() { FirebaseApp.configure() }

    @StateObject var authViewModel: AuthViewModel = .init(authService: AppDependencies.shared.authService)

    @StateObject var settingsViewModel: SettingsViewModel = .init(
        cache: AppDependencies.shared.cacheService,
        userDefaults: AppDependencies.shared.userDefaultsService
    )

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthenticated {
                    RootView()
                } else {
                    AuthScreen()
                }
            }
            .environmentObject(authViewModel)
            .environmentObject(settingsViewModel)
            .preferredColorScheme(settingsViewModel.appearance.colorScheme)
        }
    }
}
