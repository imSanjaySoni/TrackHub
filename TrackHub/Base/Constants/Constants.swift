//
//  Constants.swift
//  TrackHub
//
//  Created by Sanjay Soni on 30/07/23.
//

import Foundation
import SwiftUI

enum Keys: String {
    case AuthToken
}

enum Assets {
    enum Bold {
        static let activity = "Bold/Activity"
        static let arrowUp = "Bold/ArrowUp"
        static let arrowDown = "Bold/ArrowDown"
        static let graph = "Bold/Graph"
        static let home = "Bold/Home"
        static let setting = "Bold/Setting"
        static let mutual = "Bold/Mutual"
        static let follower = "Bold/Follower"
        static let following = "Bold/Following"
    }

    enum Outline {
        static let activity = "Outline/Activity"
        static let graph = "Outline/Graph"
        static let home = "Outline/Home"
        static let setting = "Outline/Setting"
        static let work = "Outline/Work"
        static let users = "Outline/Users"
        static let location = "Outline/Location"
        static let email = "Outline/Message"
    }

    static let trackHub = "TrackHub"
    static let gitHub = "Github"
}

extension Color {
    static var primary: Color {
        Color("Primary")
    }

    static var onPrimary: Color {
        Color("OnPrimary")
    }
}
