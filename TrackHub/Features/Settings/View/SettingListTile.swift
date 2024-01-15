//
//  SettingListTile.swift
//  TrackHub
//
//  Created by Sanjay Soni on 01/08/23.
//

import SwiftUI

struct SettingListTile<Content: View>: View {
    private let title: String
    private let trailingText: String?
    private let trailingImage: String?
    private let role: ButtonRole?
    private let action: (() -> Void)?
    private let isChecked: Bool?
    private let destination: Content?
    private let link: URL?
    
    init(_ title: String, role: ButtonRole? = nil, action: @escaping () -> Void) where Content == EmptyView {
        self.title = title
        self.role = role
        self.action = action
        self.isChecked = nil
        self.trailingText = nil
        self.trailingImage = nil
        self.destination = nil
        self.link = nil
    }
    
    init(_ title: String, isChecked: Bool, action: @escaping () -> Void) where Content == EmptyView {
        self.title = title
        self.role = nil
        self.action = action
        self.isChecked = isChecked
        self.trailingText = nil
        self.trailingImage = nil
        self.destination = nil
        self.link = nil
    }

    init(_ title: String, link: URL) where Content == EmptyView {
        self.title = title
        self.role = nil
        self.action = nil
        self.isChecked = nil
        self.trailingText = nil
        self.destination = nil
        self.trailingImage = nil
        self.link = link
    }
    
    init(_ title: String, trailingImage: String, link: URL) where Content == EmptyView {
        self.title = title
        self.role = nil
        self.action = nil
        self.isChecked = nil
        self.trailingText = nil
        self.destination = nil
        self.trailingImage = trailingImage
        self.link = link
    }
    
    init(_ title: String, @ViewBuilder destination: @escaping () -> Content) {
        self.title = title
        self.role = nil
        self.action = nil
        self.isChecked = nil
        self.trailingText = nil
        self.trailingImage = nil
        self.link = nil
        self.destination = destination()
    }
    
    init(_ title: String, trailingText: String, @ViewBuilder destination: @escaping () -> Content) {
        self.title = title
        self.role = nil
        self.action = nil
        self.isChecked = nil
        self.trailingText = trailingText
        self.trailingImage = nil
        self.link = nil
        self.destination = destination()
    }
    
    var body: some View {
        if let destination {
            NavigationLink {
                destination
            } label: {
                BuildView()
            }
            .buttonStyle(.plain)
            
        } else if let link {
            Link(destination: link) {
                BuildView()
            }

        } else {
            Button(role: role) {
                if let action {
                    action()
                }
            } label: {
                BuildView()
            }
        }
    }
    
    @ViewBuilder
    private func BuildView() -> some View {
        HStack {
            Text(title)
                
            Spacer()
            
            if let trailingText {
                Text(trailingText)
                    .foregroundColor(.secondary)
            }
            
            if let trailingImage {
                Image(systemName: trailingImage)
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.secondary)
            }
            
            if link != nil && trailingImage == nil {
                Image(systemName: "chevron.forward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
                    .foregroundColor(Color(.systemGray3))
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
            }
            
            if let isChecked {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(isChecked ? .accentColor : Color(.systemGray3))
            }
        }
        .font(.body)
        .if(role == nil) { $0.foregroundColor(.primary) }
    }
}

#Preview {
    SettingListTile("Title") {}
}
