//
//  UserProfileView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 02/08/23.
//

import CachedAsyncImage
import SwiftUI

struct UserProfileView: View {
    let user: User
    let onFollowersTap: (() -> Void)?
    let onFollowingTap: (() -> Void)?

    init(user: User) {
        self.user = user
        self.onFollowersTap = nil
        self.onFollowingTap = nil
    }

    init(user: User, onFollowersTap: @escaping () -> Void, onFollowingTap: @escaping () -> Void) {
        self.user = user
        self.onFollowersTap = onFollowersTap
        self.onFollowingTap = onFollowingTap
    }

    var body: some View {
        VStack(alignment: .leading) {
            NameAndAvatar()
            Bio()
            ProfileInfo()
        }
    }

    @ViewBuilder
    private func NameAndAvatar() -> some View {
        let avatarUrl = URL(string: user.avatarUrl)

        HStack {
            CachedAsyncImage(url: avatarUrl) { image in
                image.resizable()

            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .background(.thinMaterial)
            .clipShape(.circle)

            Spacer()
                .frame(maxWidth: 20)

            VStack(alignment: .leading) {
                if let name = user.name {
                    Text(name)
                        .font(.title)
                        .fontWeight(.bold)
                }

                Text(user.username)
                    .font(user.name == nil ? .title : .callout)
                    .foregroundColor(user.name == nil ? nil : .gray)
            }
        }
    }

    @ViewBuilder
    private func Bio() -> some View {
        if let bio = user.bio {
            Text(bio)
                .font(.callout)
                .padding(.vertical)
        }
    }

    @ViewBuilder
    private func ProfileInfo() -> some View {
        Group {
            if let company = user.company {
                Label(company, image: Assets.Outline.work)
            }

            if let location = user.location {
                Label(location, image: Assets.Outline.location)
            }

            if let email = user.email {
                Label(email, image: Assets.Outline.email)
            }

            HStack {
                Image(Assets.Outline.users)

                Button(
                    action: {
                        if let onFollowersTap {
                            onFollowersTap()
                        }
                    }) {
                        Text("\(user.followers)")
                            .fontWeight(.bold)
                            .foregroundColor(.onPrimary)

                        Text("Followers")
                    }
                    .disabled(onFollowersTap == nil)

                Text("•")

                Button(
                    action: {
                        if let onFollowingTap {
                            onFollowingTap()
                        }
                    }
                ) {
                    Text("\(user.following)")
                        .fontWeight(.bold)
                        .foregroundColor(.onPrimary)

                    Text("Following")
                }
                .disabled(onFollowingTap == nil)
            }
        }
        .foregroundColor(.gray)
        .font(.callout)
    }
}

#Preview {
    UserProfileView(user: .mock)
}
