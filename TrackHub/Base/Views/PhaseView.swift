//
//  PhaseView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 12/08/23.
//

import SwiftUI

struct RequestPhaseView<Content: View, T>: View {
    // MARK: Lifecycle

    init(_ phase: RequestPhase<T>, @ViewBuilder body: @escaping (_ data: T?) -> Content) {
        self.phase = phase
        self.dataView = body
    }

    // MARK: Internal

    var body: some View {
        BuildPhase()
    }

    // MARK: Private

    private let phase: RequestPhase<T>
    private let dataView: (_ data: T?) -> Content

    @ViewBuilder
    private func BuildPhase() -> some View {
        switch phase {
        case .idle,
             .loading:
            ProgressView()

        case .error(let message):
            Text(message)
                .font(.callout)
                .foregroundColor(.gray)

        case .data(let data):
            dataView(data)
        }
    }
}

struct PhaseView_Previews: PreviewProvider {
    static var previews: some View {
        RequestPhaseView(RequestPhase<String>.idle) { _ in
            Text("Data View")
        }
    }
}
