//
//  LoginButtonView.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import SwiftUI

struct LoginButton: View {
    // MARK: Lifecycle

    init(_ loading: Bool, _ action: @escaping () -> Void) {
        self.loading = loading
        self.action = action
    }

    // MARK: Internal

    let loading: Bool
    let action: () -> Void

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

struct LoginButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton(true) {}
    }
}
