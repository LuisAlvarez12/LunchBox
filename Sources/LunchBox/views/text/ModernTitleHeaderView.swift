//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 10/6/23.
//

import SwiftUI

public struct ModernTitleHeaderView: View {
    let subtitle: LocalizedStringKey
    let title: LocalizedStringKey

    public init(subtitle: LocalizedStringKey, title: LocalizedStringKey) {
        self.subtitle = subtitle
        self.title = title
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.largeTitle)
                .bold()
                .fontWidth(.compressed)
                .lineLimit(1)
                .aligned()
            Text(subtitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .aligned()
        }.horPadding()
    }
}

#Preview {
    ModernTitleHeaderView(subtitle: "Welcome Back", title: "Private Folder")
}
