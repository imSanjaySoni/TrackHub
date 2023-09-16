//
//  SettingScreen.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var viewModel: SettingsViewModel

    var body: some View {
        List {
            Section {
                AppearanceView()
                NotificationView()
            }

            Section {
                if let feedbackUrl = URL(string: "https://www.google.com") {
                    SettingListTile("Share Feedback", trailingImage: "plus.bubble", link: feedbackUrl)
                }

                if let appStoreUrl = URL(string: "https://www.google.com") {
                    SettingListTile("Review on AppStore", trailingImage: "star.bubble", link: appStoreUrl)
                }
            }

            Section {
                if let termsOfServiceUrl = URL(string: "https://www.google.com") {
                    SettingListTile("Terms of Service", link: termsOfServiceUrl)
                }

                if let privacyPolicyUrl = URL(string: "https://www.google.com") {
                    SettingListTile("Privacy of Policy", link: privacyPolicyUrl)
                }
            }

            Section {
                SettingListTile("Clear Cache", role: .cancel) {
                    viewModel.clearCache()
                }
            }

            Section {
                SettingListTile("Logout", role: .destructive) {
                    authViewModel.signOut()
                    viewModel.clearCache()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

private struct AppearanceView: View {
    @EnvironmentObject var viewModel: SettingsViewModel

    var body: some View {
        SettingListTile("Appearance", trailingText: viewModel.appearance.label) {
            List {
                ForEach(AppearanceType.allCases) { appearance in
                    SettingListTile(appearance.label, isChecked: viewModel.appearance == appearance) {
                        viewModel.changeAppearance(with: appearance)
                    }
                }
            }
            .navigationTitle(Text("Appearance"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct NotificationView: View {
    @State var shouldScheduleNotification: Bool = true
    @State var scheduleTime: Date = .now

    var body: some View {
        SettingListTile("Notifications") {
            List {
                Section(content: {
                    Toggle(
                        "Schedule Notification",
                        isOn: $shouldScheduleNotification)
                        .tint(.accentColor)

                    DatePicker(
                        "Schedule at",
                        selection: $scheduleTime,
                        displayedComponents: [.hourAndMinute])
                        .disabled(!shouldScheduleNotification)
                        .opacity(shouldScheduleNotification ? 1 : 0.2)
                }, footer: {
                    Text("Schedule daily alerts at \(scheduleTime)")
                })
            }
            .navigationTitle(Text("Notifications"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsScreen()
}
