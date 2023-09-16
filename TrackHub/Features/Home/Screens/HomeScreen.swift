//
//  HomeScreen.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import SwiftUI

private extension UsersType {
    var title: String {
        switch self {
        case .followers:
            "Followers"
        case .following:
            "Following"
        case .mutual:
            "Mutual Following"
        case .newFollowers:
            "New Followers"
        case .lostFollowers:
            "Follower Lost"
        case .notFollowingMeBack:
            "Not Following Me Back"
        case .iAmNotFollowingBack:
            "I'm Not Following Back"
        case .unfollowed:
            "Users I've Unfollowed"
        }
    }

    var image: String {
        switch self {
        case .followers:
            Assets.gitHub
        case .following:
            Assets.gitHub
        case .mutual:
            Assets.Bold.mutual
        case .newFollowers:
            Assets.gitHub
        case .lostFollowers:
            Assets.gitHub
        case .notFollowingMeBack:
            Assets.Bold.following
        case .iAmNotFollowingBack:
            Assets.Bold.follower
        case .unfollowed:
            Assets.gitHub
        }
    }
}

struct HomeScreen: View {
    @State private var path = NavigationPath()

    @StateObject private var vm: HomeViewModel = .init(usersService: AppDependencies.shared.usersService)

    var body: some View {
        NavigationStack(path: $path) {
            RequestPhaseView(vm.phase) { data in
                ScrollView(showsIndicators: false) {
                    // Current User Profile
                    UserProfileView(
                        user: data.user,
                        onFollowersTap: { path.append(UsersType.followers) },
                        onFollowingTap: { path.append(UsersType.following) }
                    )

                    Divider()
                        .padding(.vertical, 20)

                    // Profile Statics
                    StatisticsView(data)

                    Spacer(minLength: 20)
                }
            }
            .fillFrame()
            .padding(.horizontal)
            .refreshable { await vm.refresh() }
            .background(Color(.secondarySystemBackground))
//            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
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
        LazyVStack(alignment: .leading) {
            Section(
                header: Text("Activity")
                    .font(.title2)
            ) {
                /// New Followers
                StatisticCardView(
                    label: UsersType.newFollowers.title,
                    image: UsersType.newFollowers.image,
                    value: data.newFollowersCount,
                    state: .gain(0),
                    background: .gray,
                    action: { path.append(UsersType.newFollowers) }
                )

                /// Followers Lost
                StatisticCardView(
                    label: UsersType.lostFollowers.title,
                    image: UsersType.lostFollowers.image,
                    value: data.lostFollowersCount,
                    state: .loss(0),
                    background: .pink,
                    action: { path.append(UsersType.lostFollowers) }
                )

                /// Not Following Me Back
                StatisticCardView(
                    label: UsersType.notFollowingMeBack.title,
                    image: UsersType.notFollowingMeBack.image,
                    value: data.notFollowingMeBackCount,
                    background: .teal,
                    action: { path.append(UsersType.notFollowingMeBack) }
                )

                /// I am Not Following Back
                StatisticCardView(
                    label: UsersType.iAmNotFollowingBack.title,
                    image: UsersType.iAmNotFollowingBack.image,
                    value: data.notFollowingCount,
                    background: .blue,
                    action: { path.append(UsersType.iAmNotFollowingBack) }
                )

                /// Mutual Following
                StatisticCardView(
                    label: UsersType.mutual.title,
                    image: UsersType.mutual.image,
                    value: data.mutualsCount,
                    background: .orange,
                    action: { path.append(UsersType.mutual) }
                )

                /// Unfollowed Users
                StatisticCardView(
                    label: UsersType.unfollowed.title,
                    image: UsersType.unfollowed.image,
                    value: data.unfollowedCount,
                    background: .indigo,
                    action: { path.append(UsersType.unfollowed) }
                )
            }
        }
    }
}

#Preview { HomeScreen() }
