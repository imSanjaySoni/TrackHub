//
//  UserProfile.swift
//  TrackHub
//
//  Created by Sanjay Soni on 12/08/23.
//

import SwiftUI

struct UserProfileScreen: View {
    // MARK: Internal

    let username: String

    var body: some View {
        RequestPhaseView(vm.user) { user in
            if let user {
                ScrollView {
                    Group {
                        UserProfileView(user: user)

                        if let relation = user.relation {
                            FollowState(relation)
                        }
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

            } else {
                Text("Nothing found !")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .padding(.top, 24)
        .onAppear { vm.loadProfile(for: username) }
    }

    // MARK: Private

    @StateObject private var vm: UserProfileViewModel = .init(usersService: AppDependencies.shared.usersService)

    @State private var isFollowing: Bool = false

    @ViewBuilder
    private func FollowState(_ state: RelationType) -> some View {
        HStack {
            Image(state.icon)
                .foregroundColor(.green)
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

                Text("View this profile on GitHub")
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
        Button(
            action: {
                isFollowing.toggle()
            }) {
                HStack {
                    Image(systemName: isFollowing ? "checkmark" : "plus")
                        .foregroundColor(isFollowing ? .green : .onPrimary)

                    Text(isFollowing ? "Following" : "Follow")
                }

                .foregroundColor(.onPrimary)
                .font(.callout)
                .fontWeight(.medium)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(
                    .thinMaterial.opacity(isFollowing ? 0.5 : 1.0),
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
    UserProfileScreen(username: "imsanjaysoni")
}
