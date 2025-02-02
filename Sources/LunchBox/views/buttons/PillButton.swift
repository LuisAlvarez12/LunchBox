//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 12/26/23.
//

import SwiftUI

/// A pill-shaped button with an icon and text
public struct PillButton: View {
    /// The text to display in the button
    public let text: LocalizedStringKey
    /// The image to display in the button
    public let image: ParselableImage

    /// Creates a new pill button
    /// - Parameters:
    ///   - text: The text to display in the button
    ///   - image: The image to display in the button
    public init(text: LocalizedStringKey, image: ParselableImage) {
        self.text = text
        self.image = image
    }

    public var body: some View {
        Label(title: {
            Text(text)
                .foregroundStyle(AppThemeManager.shared.currentTheme.text.primary)
        }, icon: {
            image.createImage(frame: 18)
        })
        .font(.footnote)
        .bold()
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 8).foregroundStyle(Color.systemSecondary)
        }
    }
}

#Preview {
    HorizontalScrollview {
        PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
        PillButton(text: "Favorites", image: ParselableImage(networkImage: ParselableNetworkImage(urlString: ParselableNetworkImage.buildLink(parentName: "General", assetName: "icon-folder-square"), systemImage: "folder.fill")))
    }
}
