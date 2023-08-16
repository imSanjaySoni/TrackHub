//
//  SettingListTile.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import SwiftUI

struct SettingListTile: View {
    let title: String
    let trailingText: String?

    init(_ title: String) {
        self.title = title
        self.trailingText = nil
    }

    init(_ title: String, trailingText: String) {
        self.title = title
        self.trailingText = trailingText
    }

    var body: some View {
        HStack {
            Text(title)

            Spacer()

            if let trailingText {
                Text(trailingText)
            }

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    SettingListTile("Title")
}
