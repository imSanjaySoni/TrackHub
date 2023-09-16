//
//  PhaseView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 12/08/23.
//

import SwiftUI

struct RequestPhaseView<Content: View, T>: View {
    private let phase: RequestPhase<T>
    private let dataView: (_ data: T) -> Content

    init(_ phase: RequestPhase<T>, @ViewBuilder body: @escaping (_ data: T) -> Content) {
        self.phase = phase
        self.dataView = body
    }

    var body: some View {
        BuildPhase()
    }

    @ViewBuilder
    private func BuildPhase() -> some View {
        switch phase {
        case .idle,
             .loading:
            LoadingView()

        case .empty:
            Text("Nothing Found..")
                .font(.callout)
                .foregroundColor(.gray)

        case .error(let message):
            Text(message)
                .font(.callout)
                .foregroundColor(.gray)

        case .data(let data):
            dataView(data!)
        }
    }
}

#Preview {
    RequestPhaseView(RequestPhase<String>.idle) { _ in
        Text("Data View")
    }
}
