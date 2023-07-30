//
//  InfoCardView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 13/08/23.
//

import SwiftUI

struct InfoCardView: View {
    // MARK: Lifecycle

    init(label: String, image: String, value: Int, state: State = .idle, action: @escaping () -> Void) {
        self.label = label
        self.image = image
        self.value = value
        self.state = state
        self.action = action
    }

    // MARK: Internal

    enum State {
        case idle
        case gain
        case loss
    }

    var body: some View {
        HStack(spacing: 20) {
            Image(image)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.green)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 0) {
                    Text("\(value)")
                        .font(.title2)
                        .foregroundColor(.onPrimary)

                    switch state {
                    case .idle:
                        EmptyView()

                    case .gain:
                        Image(Assets.Bold.arrowUp)
                            .foregroundColor(.green)
                    case .loss:
                        Image(Assets.Bold.arrowDown)
                            .foregroundColor(.red)
                    }
                }

                Text(label)
                    .font(.callout)
            }

            Spacer()

            Image(systemName: "chevron.right")
        }
        .foregroundColor(.gray)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .if(colorScheme == .dark) {
            $0.background(.ultraThinMaterial.opacity(0.7))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray.opacity(0.3))
        )
        .cornerRadius(8)
        .onTapGesture { action() }
    }

    // MARK: Private

    private let label: String
    private let image: String
    private let value: Int
    private let state: State
    private let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme
}

struct InfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        InfoCardView(label: "Follow Gain", image: Assets.Bold.arrowDown, value: 20) {}
    }
}
