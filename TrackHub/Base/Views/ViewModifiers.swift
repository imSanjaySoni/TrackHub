//
//  ViewModifers.swift
//  TrackHub
//
//  Created by Sanjay Soni on 12/08/23.
//

import SwiftUI

struct FillSize: ViewModifier {
    // MARK: Lifecycle

    init(alignment: Alignment = .center) {
        self.alignment = alignment
    }

    // MARK: Internal

    let alignment: Alignment

    func body(content: Content) -> some View {
        content
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: alignment
            )
    }
}

extension View {
    func fillFrame(alignment: Alignment = Alignment.center) -> some View {
        modifier(FillSize(alignment: alignment))
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
