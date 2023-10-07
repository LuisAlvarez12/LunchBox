//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 10/6/23.
//

import SwiftUI

public struct ModernTitleHeaderView: View {
    let subtitle: String
    let title: String

    public init(subtitle: String, title: String) {
        self.subtitle = subtitle
        self.title = title
    }

    public var body: some View {
        VStack(spacing: 2) {
            Text(subtitle)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .aligned()

            Text(title)
                .font(.largeTitle)
                .bold()
                .fontWidth(.expanded)
                .lineLimit(1)
                .aligned()
        }.horPadding()
    }
}

#Preview {
    ModernTitleHeaderView(subtitle: "Welcome Back", title: "Private Folder")
}
