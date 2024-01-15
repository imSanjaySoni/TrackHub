//
//  HomeScreen.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import SwiftUI

struct HomeScreen: View {
    @State private var path = NavigationPath()

    @StateObject private var vm: HomeViewModel = .init(usersService: AppDependencies.shared.usersService)

    var body: some View {
        NavigationStack(path: $path) {
            RequestPhaseView(vm.phase) { data in
                List {
                    // Current User Profile
                    UserProfileView(
                        user: data.user,
                        onFollowersTap: { path.append(UsersType.followers) },
                        onFollowingTap: { path.append(UsersType.following) }
                    )
                    .listRowInsets(.none)
                    .listSectionSeparator(.hidden)
                    .listRowBackground(Color.clear)

                    // Profile Statics
                    StatisticsView(data)
                }
            }
            .padding(.top, -40)
            .listStyle(.grouped)
            .scrollIndicators(.hidden)
            .refreshable { await vm.refresh() }
            .navigationBarTitle("Home", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { path.append("settings") }) {
                        Image(Assets.Outline.setting)
                    }
                }
            }
            .navigationDestination(for: String.self) { _ in SettingsScreen() }
            .navigationDestination(for: UsersType.self) { UsersScreen(userType: $0, title: $0.title) }
        }
    }

    @ViewBuilder
    private func StatisticsView(_ data: HomeScreenDataModel) -> some View {
        Section {
            /// New Followers
            NavigationLink(value: UsersType.newFollowers) {
                StatisticCardView(
                    label: UsersType.newFollowers.title,
                    image: UsersType.newFollowers.image,
                    value: data.newFollowersCount,
                    state: .gain(0),
                    background: .gray
                )
            }

            /// Followers Lost
            NavigationLink(value: UsersType.lostFollowers) {
                StatisticCardView(
                    label: UsersType.lostFollowers.title,
                    image: UsersType.lostFollowers.image,
                    value: data.lostFollowersCount,
                    state: .loss(0),
                    background: .pink
                )
            }

            /// Not Following Me Back
            NavigationLink(value: UsersType.notFollowingMeBack) {
                StatisticCardView(
                    label: UsersType.notFollowingMeBack.title,
                    image: UsersType.notFollowingMeBack.image,
                    value: data.notFollowingMeBackCount,
                    background: .teal
                )
            }

            /// I am Not Following Back
            NavigationLink(value: UsersType.iAmNotFollowingBack) {
                StatisticCardView(
                    label: UsersType.iAmNotFollowingBack.title,
                    image: UsersType.iAmNotFollowingBack.image,
                    value: data.notFollowingCount,
                    background: .blue
                )
            }

            /// Mutual Following
            NavigationLink(value: UsersType.mutual) {
                StatisticCardView(
                    label: UsersType.mutual.title,
                    image: UsersType.mutual.image,
                    value: data.mutualsCount,
                    background: .orange
                )
            }

            /// Unfollowed Users
            NavigationLink(value: UsersType.unfollowed) {
                StatisticCardView(
                    label: UsersType.unfollowed.title,
                    image: UsersType.unfollowed.image,
                    value: data.unfollowedCount,
                    background: .indigo
                )
            }
        }
    }
}

#Preview { HomeScreen() }
