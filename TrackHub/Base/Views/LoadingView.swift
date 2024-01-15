//
//  LoadingView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 16/08/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack(spacing: 12) {
            ProgressView()

            Text("Loading..")
                .foregroundColor(.onPrimary)
        }
    }
}

#Preview {
    LoadingView()
}
