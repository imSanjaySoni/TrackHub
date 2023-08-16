//
//  HomeScreen.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import SwiftUI

struct HomeScreen: View {
    // MARK: Internal

    var body: some View {
        NavigationStack(path: $path) {
            RequestPhaseView(vm.user) { user in
                if let user {
                    ScrollView(showsIndicators: false) {
                        UserProfileView(
                            user: user,
                            onFollowersTap: {
                                path.append(.Followers)
                            },
                            onFollowingTap: {
                                path.append(.Following)
                            }
                        )

                        Divider()
                            .padding(.vertical, 20)

                        InfoGrids()

                        Spacer(minLength: 100)
                    }

                } else {
                    Text("Nothing found !")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            .navigationDestination(
                for: UsersType.self,
                destination: { UsersScreen(usersType: $0, title: $0.rawValue) }
            )
            .padding(.horizontal)
            .fillFrame()
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: Private

    @State private var path: [UsersType] = []

    @StateObject private var vm: HomeViewModel = .init(usersService: AppDependencies.shared.usersService)

    @ViewBuilder
    private func InfoGrids() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity")
                .font(.title2)
                .foregroundColor(.onPrimary)

            InfoCardView(
                label: "New Followers",
                image: Assets.gitHub,
                value: 1230,
                progress: 12,
                state: .gain
            ) {
                path.append(.Followers)
            }

            InfoCardView(
                label: "Follower Lost",
                image: Assets.Bold.arrowDown,
                value: 12,
                progress: 12,
                state: .loss
            ) {}

            InfoCardView(
                label: "Not Following Me Back",
                image: Assets.Bold.follower,
                value: 10
            ) {}

            InfoCardView(
                label: "I'm Not Following Back",
                image: Assets.Bold.following,
                value: 20
            ) {}

            InfoCardView(
                label: "Mutual Following",
                image: Assets.Bold.mutual,
                value: 31
            ) {}

            InfoCardView(
                label: "Users I've Unfollowed",
                image: Assets.Bold.graph,
                value: 120
            ) {}
        }
    }
}

#Preview {
    HomeScreen()
}
