//
//  SwiftUIView 2.swift
//
//
//  Created by Luis Alvarez on 5/20/24.
//

import SwiftUI

/// A view component that displays a large banner with an image, title, and subtitle.
/// This banner is typically used for prominent displays or featured content.
///
/// The banner consists of:
/// - A large image at the top
/// - A title below the image with customizable color
/// - A subtitle at the bottom
public struct LargeImageBanner: View {
    public let image: ParselableImage
    public let title: LocalizedStringKey
    public let subtitle: LocalizedStringKey
    public var titleColor: Color = .blue

    public init(image: ParselableImage, title: LocalizedStringKey, subtitle: LocalizedStringKey, titleColor: Color = .blue) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.titleColor = titleColor
    }

    public var body: some View {
        VStack(alignment: .leading) {
            image
                .createImage(frame: .infinity)
                .cornerRadius(20, corners: .allCorners)
            Text(title).font(.title2).bold().foregroundStyle(titleColor).aligned()
            Text(subtitle).font(.footnote)
        }.padding()
    }
}

#Preview {
    ScrollView {
        LargeImageBanner(image: ParselableImage(parentName: "Uncover", assetName: "icon-woman-reading", systemImage: "book"), title: "Get Premium", subtitle: "Read all of your files, and uncover new features")
    }
}
