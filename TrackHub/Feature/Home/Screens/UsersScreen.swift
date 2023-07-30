//
//  UsersScreen.swift
//  TrackHub
//
//  Created by Sanjay Soni on 10/08/23.
//

import SwiftUI

struct UsersScreen: View {
    // MARK: Internal

    let usersType: UsersType
    let title: String

    var body: some View {
        RequestPhaseView(vm.users) { users in
            if let users, !users.isEmpty {
                List {
                    ForEach(users) { user in
                        UserCardView(user: user) { isFollowing in
                            vm.followOrUnfollowUser(with: user.username, for: isFollowing)
                        }
                        .onTapGesture {
                            selectedUser = user
                        }
                    }
                }
            } else {
                Text("Nothing found !")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
        }
        .listStyle(.plain)
        .navigationTitle(title)
        .onAppear { vm.loadUsers(for: usersType) }
        .sheet(
            item: $selectedUser,
            content: { user in
                UserProfileScreen(username: user.username)
                    .presentationDetents([.fraction(0.7), .large])
                    .presentationDragIndicator(.automatic)
            })
    }

    // MARK: Private

    @StateObject private var vm: UsersViewModel = .init(UsersServiceImp(apiClient: GithubApiClientImp()))
    @State private var selectedUser: BasicUser? = nil
}

struct UsersScreen_Previews: PreviewProvider {
    static var previews: some View {
        UsersScreen(usersType: .Followers, title: "Followers")
    }
}
