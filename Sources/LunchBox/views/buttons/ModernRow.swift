//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 5/15/24.
//

import SwiftUI

public struct ModernRow: View {
    public let text: LocalizedStringKey
    public let image: String
    public var color: Color

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
