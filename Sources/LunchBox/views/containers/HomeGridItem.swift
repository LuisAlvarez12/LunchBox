//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 10/4/23.
//

import SwiftUI

public struct HomeGridItem: View {
    public let image: ParselableImage
    public let text: String

    public init(image: ParselableImage, text: String) {
        self.image = image
        self.text = text
    }

    public var body: some View {
        VStack {
            image.createImage(frame: 46, color: AppThemeManager.shared.currentTheme.primary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(UIColor.secondarySystemBackground))
                )

            Text(text)
                .font(.footnote)
                .foregroundStyle(AppThemeManager.shared.currentTheme.text.primary)
        }
    }
}

#Preview {
    HomeGridItem(image: ParselableImage(systemImage: ParselableSystemImage("folder")), text: "Test")
}
