//
//  UserCardView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 10/08/23.
//

import CachedAsyncImage
import SwiftUI

struct UserCardView: View {
    let user: BasicUser
    let onFollowStateChange: (Bool) -> Void

    @State private var isFollowing: Bool

    init(user: BasicUser, onFollowStateChange: @escaping (Bool) -> Void) {
        self.user = user
        self.onFollowStateChange = onFollowStateChange

        isFollowing = {
            guard let relation = user.relation else {
                return false
            }

            return switch relation {
            case .follower,
                 .noRelation:
                false
            case .following,
                 .mutual:
                true
            }
        }()
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Avatar()
            BasicDetails()
            Spacer()
            FollowUnfollowButton()
        }
    }

    // MARK: Private

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

                    Image(user.relation!.icon)
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

#Preview {
    UserCardView(user: BasicUser.mock) { _ in }
}
