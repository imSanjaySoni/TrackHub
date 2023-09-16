//
//  LoginButtonView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import SwiftUI

struct LoginButton: View {
    let loading: Bool
    let action: () -> Void

    init(_ loading: Bool, _ action: @escaping () -> Void) {
        self.loading = loading
        self.action = action
    }

    var body: some View {
        Button { action() } label: {
            Group {
                if loading {
                    ProgressView()

                } else {
                    HStack(spacing: 12) {
                        Image(Assets.gitHub)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)

                        Text("Sign in with GitHub")
                            .font(.headline)
                    }
                }
            }
        }
        .foregroundColor(.white)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
    }
}

#Preview {
    LoginButton(true) {}
}
