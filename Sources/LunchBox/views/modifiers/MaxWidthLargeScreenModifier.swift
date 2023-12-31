//
//  MaxWidthLargeScreenModifier.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public extension View {
    func fullWidth(ipadWidth: CGFloat) -> some View {
        modifier(MaxWidthLargeScreenModifier(ipadMaxWidth: ipadWidth))
    }
}

@available(iOS 16.0, *)
public struct MaxWidthLargeScreenModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let ipadMaxWidth: CGFloat

    public func body(content: Content) -> some View {
        if horizontalSizeClass == .compact {
            return content.frame(idealWidth: .infinity, maxWidth: .infinity)
        } else {
            return content.frame(idealWidth: ipadMaxWidth, maxWidth: ipadMaxWidth)
        }
    }
}

@available(iOS 16.0.0, *)
struct MaxWidthLargeScreenModifier_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButton(text: "Submit", action: {})
                .fullWidth()
        }
    }
}
