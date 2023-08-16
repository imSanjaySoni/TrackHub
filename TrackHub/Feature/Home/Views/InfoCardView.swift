//
//  InfoCardView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 13/08/23.
//

import SwiftUI

struct InfoCardView: View {
    // MARK: Lifecycle

    init(label: String, image: String, value: Int, progress: Int? = nil, state: ProgressType = .idle, action: @escaping () -> Void) {
        self.label = label
        self.image = image
        self.value = value
        self.progress = progress
        self.state = state
        self.action = action
    }

    // MARK: Internal

    enum ProgressType {
        case idle
        case gain
        case loss
    }

    var body: some View {
        HStack(spacing: 20) {
            Image(image)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.onPrimary)

            VStack(alignment: .leading) {
                HStack(spacing: 6) {
                    Text("\(value)")
                        .font(.title2)
                        .foregroundColor(.onPrimary)

                    HStack(spacing: 0) {
                        switch state {
                        case .idle:
                            EmptyView()
                        case .gain:
                            Image(Assets.Bold.arrowUp)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                                .foregroundColor(.green)
                        case .loss:
                            Image(Assets.Bold.arrowDown)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                                .foregroundColor(.red)
                        }

                        if let progress {
                            Text("\(progress)")
                                .font(.callout)
                                .foregroundColor(.onPrimary)
                        }
                    }
                }

                Text(label)
                    .font(.caption)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.3))
        }
        .foregroundColor(.gray)
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial.opacity(0.7))
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
    private let progress: Int?
    private let state: ProgressType
    private let action: () -> Void
}

struct InfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        InfoCardView(label: "Follow Gain", image: Assets.Bold.arrowDown, value: 20) {}
    }
}
