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
    // MARK: Lifecycle

    init() {
        FirebaseApp.configure()
    }

    // MARK: Internal

    @StateObject var authViewModel: AuthViewModel = .init(authService: AuthServiceImp())

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthenticated {
                    RootView()
                } else {
                    AuthScreen()
                }
            }.environmentObject(authViewModel)
        }
    }
}
