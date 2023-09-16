//
//  UserProfile.swift
//  TrackHub
//
//  Created by Sanjay Soni on 12/08/23.
//

import SwiftUI

struct UserProfileScreen: View {
    @StateObject private var vm: UserProfileViewModel

    init(username: String, relation: UserRelationType?) {
        let value = UserProfileViewModel(
            usersService: AppDependencies.shared.usersService,
            username: username,
            relation: relation
        )
        _vm = StateObject(wrappedValue: value)
    }

    var body: some View {
        RequestPhaseView(vm.user) { user in
            ScrollView {
                Group {
                    UserProfileView(user: user)
                    FollowState(vm.relation)
                }
                .fillFrame(alignment: .topLeading)

                Spacer()
                    .frame(height: 32)

                if let url = URL(string: user.profileUrl) {
                    GitHubLinkButton(profileUrl: url)
                        .padding(.bottom)
                }

                FollowButton()
            }
        }
        .padding()
        .padding(.top, 24)
        .onAppear { vm.loadProfile() }
    }

    @ViewBuilder
    private func FollowState(_ state: UserRelationType) -> some View {
        HStack {
            Image(state.icon)
                .foregroundColor(state == .noRelation ? .gray : .green)
                .containerShape(Circle())

            Text(state.label)
        }
        .font(.callout)
        .foregroundColor(.gray)
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private func GitHubLinkButton(profileUrl url: URL) -> some View {
        Link(destination: url) {
            HStack {
                Image(Assets.gitHub)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.onPrimary)
                    .frame(width: 20, height: 20)

                Text("View on GitHub")
            }
            .foregroundColor(.onPrimary)
            .font(.callout)
            .fontWeight(.medium)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray.opacity(0.3))
            )
        }
    }

    @ViewBuilder
    private func FollowButton() -> some View {
        Button(action: vm.followOrUnfollow) {
            HStack {
                Image(systemName: vm.isFollowing ? "checkmark" : "plus")
                    .foregroundColor(vm.isFollowing ? .green : .onPrimary)

                Text(vm.isFollowing ? "Following" : "Follow")
            }

            .foregroundColor(.onPrimary)
            .font(.callout)
            .fontWeight(.medium)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(
                .thinMaterial.opacity(vm.isFollowing ? 0.5 : 1.0),
                in: RoundedRectangle(cornerRadius: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray.opacity(0.3))
            )
        }
    }
}

#Preview {
    UserProfileScreen(username: "imSanjaySoni", relation: .follower)
}
