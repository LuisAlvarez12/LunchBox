//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 12/26/23.
//

import SwiftUI

public struct PillButton: View {
    public let text: LocalizedStringKey
    public let image: ParselableImage

    public init(text: LocalizedStringKey, image: ParselableImage) {
        self.text = text
        self.image = image
    }

    public var body: some View {
        Label(title: {
            Text(text)
                .foregroundStyle(Color.LBMonoScreenOffTone)
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
