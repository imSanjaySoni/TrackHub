//
//  AuthScreen.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import SwiftUI

struct AuthScreen: View {
    @EnvironmentObject private var vm: AuthViewModel

    var body: some View {
        VStack {
            Spacer()
            Spacer()

            Image(Assets.trackHub)
                .resizable()
                .scaledToFit()
                .frame(height: 36)
                .foregroundColor(.onPrimary)

            Spacer()

            LoginButton(vm.authPhase == .loading) {
                vm.signInWithGithub()
            }

            Spacer()
        }
    }
}

#Preview {
    AuthScreen()
}
