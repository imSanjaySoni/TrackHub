//
//  AppearanceModel.swift
//  TrackHub
//
//  Created by Sanjay Soni on 19/08/23.
//

import Foundation
import SwiftUI

enum AppearanceType: Codable, CaseIterable, Identifiable {
    case automatic
    case dark
    case light

    var id: Self {
        return self
    }

    var label: String {
        switch self {
        case .automatic:
            "Automatic"
        case .dark:
            "Dark"
        case .light:
            "Light"
        }
    }
}

extension AppearanceType {
    var colorScheme: ColorScheme? {
        switch self {
        case .automatic:
            nil
        case .dark:
            .dark
        case .light:
            .light
        }
    }
}
