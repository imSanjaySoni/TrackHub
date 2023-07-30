//
//  AuthScreen.swift
//  TrackHub
//
//  Created by Sanjay Soni on 29/07/23.
//

import SwiftUI

struct AuthScreen: View {
//    @StateObject private var vm: AuthViewModel()

    var body: some View {
        VStack {
            Text("Login")
            Button {} label: {
                Image("AppIcon")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)
            }
        }
    }
}

struct AuthScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthScreen()
    }
}
