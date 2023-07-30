//
//  RootView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 31/07/23.
//

import SwiftUI

struct RootView: View {
    // MARK: Internal

    var body: some View {
        TabView(selection: $activeTab) {
            HomeScreen()
                .tabItem {
                    Label(Tabs.home.label, image: Tabs.home.icon(activeTab == Tabs.home))
                }
                .tag(Tabs.home)

            InsightsScreen()
                .tabItem {
                    Label(Tabs.insights.label, image: Tabs.insights.icon(activeTab == Tabs.insights))
                }
                .tag(Tabs.insights)

            SettingsScreen()
                .tabItem {
                    Label(Tabs.settings.label, image: Tabs.settings.icon(activeTab == Tabs.settings))
                }
                .tag(Tabs.settings)
        }
    }

    // MARK: Private

    private enum Tabs {
        case home
        case insights
        case settings

        // MARK: Internal

        var label: String {
            switch self {
            case .home:
                return "Home"
            case .insights:
                return "Insights"
            case .settings:
                return "Settings"
            }
        }

        func icon(_ isActive: Bool) -> String {
            switch self {
            case .home:
                return isActive ? Assets.Bold.home : Assets.Outline.home
            case .insights:
                return isActive ? Assets.Bold.activity : Assets.Outline.activity
            case .settings:
                return isActive ? Assets.Bold.setting : Assets.Outline.setting
            }
        }
    }

    @State private var activeTab: Tabs = .home
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
