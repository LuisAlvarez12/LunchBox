//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 5/20/24.
//

import SwiftUI

public struct MediumImageBanner: View {
    public let image: ParselableImage
    public let title: LocalizedStringKey
    public let subtitle: LocalizedStringKey

    public init(image: ParselableImage, title: LocalizedStringKey, subtitle: LocalizedStringKey) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack {
            image
                .createImage(frame: .infinity)
                .cornerRadius(20, corners: .allCorners)

            Text(title).font(.subheadline).bold().aligned()
                .foregroundStyle(AppThemeManager.shared.currentTheme.text.primary)
                .multilineTextAlignment(.leading)
            Text(subtitle).foregroundStyle(Color.gray).font(.footnote).aligned()
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    VStack {
        HStack {
            Button(action: {}, label: {
                MediumImageBanner(image: ParselableImage(parentName: "Uncover", assetName: "icon-woman-reading", systemImage: "book"), title: "Get Premium", subtitle: "Read all of your files, and uncover new features")
            })

            MediumImageBanner(image: ParselableImage(parentName: "Uncover", assetName: "icon-woman-reading", systemImage: "book"), title: "Get Premium", subtitle: "Read all of your files, and uncover new features")
        }
    }
}
