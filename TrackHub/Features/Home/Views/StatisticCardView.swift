//
//  StatisticsCardView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 13/08/23.
//

import SwiftUI

struct StatisticCardView: View {
    private let label: String
    private let image: String
    private let value: Int
    private let state: ProgressType
    private let background: Color

    init(
        label: String,
        image: String,
        value: Int,
        progress: Int? = nil,
        state: ProgressType = .idle,
        background: Color
    ) {
        self.label = label
        self.image = image
        self.value = value
        self.state = state
        self.background = background
    }

    enum ProgressType {
        case idle
        case gain(Int)
        case loss(Int)
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(image)
                .resizable()
                .padding(4)
                .background(background)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .cornerRadius(4)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("\(value)")
                        .font(.title3)
                        .foregroundColor(.onPrimary)

                    HStack(spacing: 0) {
                        switch state {
                        case .idle:
                            EmptyView()
                        case .gain(let gainBy):
                            Group {
                                Image(Assets.Bold.arrowUp)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 16)
                                    .foregroundColor(.green)

                                Text("\(gainBy)")
                                    .font(.callout)
                                    .foregroundColor(.onPrimary)
                            }

                        case .loss(let lossBy):
                            Group {
                                Image(Assets.Bold.arrowDown)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 16)
                                    .foregroundColor(.red)

                                Text("\(lossBy)")
                                    .font(.callout)
                                    .foregroundColor(.onPrimary)
                            }
                        }
                    }
                }

                Text(label)
                    .font(.caption)
            }
        }
        .foregroundColor(.gray)
    }
}

#Preview {
    StatisticCardView(
        label: "Follow Gain",
        image: Assets.Bold.arrowDown,
        value: 20,
        background: .green
    )
}
