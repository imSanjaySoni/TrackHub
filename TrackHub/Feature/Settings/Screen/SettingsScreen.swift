//
//  SettingScreen.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SettingListTile("Appearance", trailingText: "System")
                    SettingListTile("Appearance")
                    SettingListTile("Appearance")
                }

                Section {
                    SettingListTile("Share Feedback")
                }

                Section {
                    Button {} label: {
                        Text("Clear cache")
                    }
                }

                Section {
                    Button(role: .destructive) {} label: {
                        HStack {
                            Text("Logout")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
