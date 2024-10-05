//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 6/19/24.
//

import SwiftUI

public struct LargeSectionHeader: View {
    public let title: LocalizedStringKey
    public var showImage: Bool = true
    public var image: String = "arrow.right"
    public var onButtonClick: (() -> Void)? = nil

    public init(title: LocalizedStringKey) {
        self.title = title
    }

    public init(title: LocalizedStringKey, image: String) {
        self.title = title
        self.image = image
    }

    public init(title: LocalizedStringKey, showImage: Bool, image: String, onButtonClick: (() -> Void)? = nil) {
        self.title = title
        self.showImage = showImage
        self.image = image
        self.onButtonClick = onButtonClick
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .medium, design: .default))

            Spacer()

            if showImage {
                if let onButtonClick {
                    Button(action: {
                        onButtonClick()
                    }, label: {
                        imageView
                            .contentShape(.hoverEffect, .circle)
                            .hoverEffect()
                    }).buttonStyle(.plain)
                } else {
                    imageView
                }
            }

        }.padding(.top)
    }

    var imageView: some View {
        Image(systemName: image)
            .bold()
            .foregroundStyle(AppThemeManager.shared.currentTheme.text.primary)
            .padding(6)
            .background(Circle().fill(Color.secondary.opacity(0.2)))
    }
}

#Preview {
    LargeSectionHeader(title: "Home")
}
