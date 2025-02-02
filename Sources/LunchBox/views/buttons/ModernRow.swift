//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 5/15/24.
//

import SwiftUI

/// A modern-styled row view with an icon, text, and chevron
public struct ModernRow: View {
    /// The text to display in the row
    public let text: LocalizedStringKey
    /// The system image name for the row's icon
    public let image: String
    /// The background color for the icon
    public var color: Color

    /// Creates a new modern row
    /// - Parameters:
    ///   - text: The text to display in the row
    ///   - image: The system image name for the row's icon
    ///   - color: The background color for the icon
    public init(text: LocalizedStringKey, image: String, color: Color) {
        self.text = text
        self.image = image
        self.color = color
    }

    public var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .squareFrame(length: 24)
                .foregroundStyle(Color.white)
                .bold()
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                }.padding(12)

            Text(text)
                .foregroundStyle(AppThemeManager.shared.currentTheme.text.primary)
                .font(.title3)
                .aligned()
                .bold()

            Image(systemName: "chevron.right")
                .foregroundStyle(AppThemeManager.shared.currentTheme.text.primary)
                .font(.title3)
                .padding(.trailing)
        }
        .background {
            Color.systemSecondary
        }.clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ModernRow(text: "This is a test", image: "house", color: .red)
}
