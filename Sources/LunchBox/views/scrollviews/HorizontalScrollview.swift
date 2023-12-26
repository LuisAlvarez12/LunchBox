//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 12/26/23.
//

import SwiftUI

public struct HorizontalScrollview<Content>: View where Content: View {
    public let spacing: CGFloat
    public let initialSpacing: CGFloat
    @ViewBuilder public var content: () -> Content

    public init(spacing: CGFloat = 16, initialSpacing: CGFloat = 0, @ViewBuilder _ content: @escaping () -> Content) {
        self.spacing = spacing
        self.initialSpacing = initialSpacing
        self.content = content
    }

    public init(@ViewBuilder _ content: @escaping () -> Content) {
        spacing = 16
        initialSpacing = 0
        self.content = content
    }

    public var body: some View {
        ScrollView(.horizontal, content: {
            HStack(spacing: spacing, content: {
                if initialSpacing > 0 {
                    Spacer().frame(maxWidth: initialSpacing)
                }
                content()
            })
        }).scrollIndicators(.never)
    }
}

#Preview {
    VStack {
        HorizontalScrollview(spacing: 32) {
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
        }

        HorizontalScrollview(spacing: 4, initialSpacing: 16) {
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
        }

        HorizontalScrollview(spacing: 24, initialSpacing: 16) {
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
            PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage("folder", color: Color.green)))
        }
    }
}
