//
//  UserCardView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 10/08/23.
//

import CachedAsyncImage
import SwiftUI

struct UserCardView: View {
    // MARK: Lifecycle

    init(user: BasicUser, onFollowStateChange: @escaping (Bool) -> Void) {
        self.user = user
        self.onFollowStateChange = onFollowStateChange
    }

    // MARK: Internal

    let user: BasicUser
    let onFollowStateChange: (Bool) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Avatar()
            BasicDetails()
            Spacer()
            FollowUnfollowButton()
        }
    }

    // MARK: Private

    @State private var isFollowing: Bool = true

    @ViewBuilder
    private func Avatar() -> some View {
        CachedAsyncImage(url: URL(string: user.avatarUrl)) { image in
            image
                .resizable()

        } placeholder: {
            ProgressView()
        }
        .frame(width: 56, height: 56)
        .background(.thinMaterial)
        .clipShape(Circle())
        .if(user.relation != nil) { view in
            view.overlay {
                GeometryReader { proxy in
                    let badgeSize: Double = 20
                    let x: Double = proxy.size.width - (badgeSize / 2)
                    let y: Double = proxy.size.height - (badgeSize / 2)

                    Image(Assets.Bold.mutual)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: badgeSize, height: badgeSize)
                        .background(.black.gradient)
                        .containerShape(Circle())
                        .position(.init(x: x, y: y))
                }
            }
        }
    }

    @ViewBuilder
    private func BasicDetails() -> some View {
        Text(user.username)
            .font(.headline)
    }

    @ViewBuilder
    private func FollowUnfollowButton() -> some View {
        Button(isFollowing ? "Following" : "Follow") {
            isFollowing.toggle()
            onFollowStateChange(isFollowing)
        }
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundColor(.onPrimary)
        .buttonStyle(.bordered)
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView(user: BasicUser.mock) { _ in }
    }
}
