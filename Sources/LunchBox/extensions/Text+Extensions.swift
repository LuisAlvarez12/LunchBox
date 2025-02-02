//
//  Text+Extensions.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public extension Text {
    /// Applies a semi-bold font weight to the text
    /// - Returns: A text view with semi-bold font weight
    public func semiBold() -> Text {
        fontWeight(.semibold)
    }

    /// Applies a rounded system font with customizable size and weight
    /// - Parameters:
    ///   - size: The font size (default: 18)
    ///   - weight: The font weight (default: .regular)
    /// - Returns: A text view with the specified rounded font settings
    public func roundFont(_ size: CGFloat = 18, weight: Font.Weight = .regular) -> Text {
        font(.system(size: size, weight: weight, design: .rounded))
    }
}

@available(iOS 16.0, *)
struct TextExtensions_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            Text(GenericFaker.paragraph).semiBold()
            Text(GenericFaker.paragraph).roundFont()
        }
    }
}
