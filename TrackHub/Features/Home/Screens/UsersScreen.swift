//
//  UsersScreen.swift
//  TrackHub
//
//  Created by Sanjay Soni on 10/08/23.
//

import SwiftUI

struct UsersScreen: View {
    private let userType: UsersType
    private let title: String

    init(userType: UsersType, title: String) {
        self.userType = userType
        self.title = title
    }

    @State private var selectedUser: BasicUser? = nil

    @StateObject private var vm: UsersViewModel = .init(usersService: AppDependencies.shared.usersService)

    var body: some View {
        RequestPhaseView(vm.users, body: { users in
            List {
                ForEach(users) { user in
                    UserCardView(user: user) { isFollowing in
                        vm.followOrUnfollowUser(with: user.username, for: isFollowing)
                    }
                    .onTapGesture { selectedUser = user }
                }
            }
        })
        .onAppear { vm.loadUsers(for: userType) }
        .listStyle(.plain)
        .navigationTitle(title)
        .searchable(text: $vm.searchQuery)
        .sheet(
            item: $selectedUser,
            content: {
                UserProfileScreen(username: $0.username, relation: $0.relation)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.automatic)
            }
        )
    }
}

#Preview {
    UsersScreen(userType: .followers, title: "Followers")
}
