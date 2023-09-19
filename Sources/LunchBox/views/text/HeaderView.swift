//
//  HeaderView.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct TitleHeaderView: View {
    var subtitle: LocalizedStringKey? = nil
    let title: LocalizedStringKey

    var subtitleSize: CGFloat = 28
    var titleSize: CGFloat = 42

    var primaryColor: Color? = nil

    public init(subtitle: LocalizedStringKey? = nil, title: LocalizedStringKey, subtitleSize: CGFloat = 28, titleSize: CGFloat = 42, primaryColor: Color? = nil) {
        self.subtitle = subtitle
        self.title = title
        self.subtitleSize = subtitleSize
        self.titleSize = titleSize
        self.primaryColor = primaryColor
    }

    public var body: some View {
        Text(subtitle ?? "")
            .font(.callout)
            .multilineTextAlignment(.center)
            .padding(.top, subtitleSize)
            .foregroundStyle(Color.secondary)

        if let primaryColor {
            Text(title)
                .font(.system(size: titleSize, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(primaryColor)
                .shadow(color: primaryColor, radius: 4)
        } else {
            Text(title)
                .font(.system(size: titleSize, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
        }
    }
}

@available(iOS 16.0.0, *)
public struct AlignedTitleHeaderView: View {
    var subtitle: String? = nil
    let title: String

    var subtitleSize: CGFloat = 28
    var titleSize: CGFloat = 42

    public init(subtitle: String? = nil, title: String, subtitleSize: CGFloat = 28, titleSize: CGFloat = 42) {
        self.subtitle = subtitle
        self.title = title
        self.subtitleSize = subtitleSize
        self.titleSize = titleSize
    }

    public var body: some View {
        Text(subtitle ?? "")
            .font(.callout)
            .multilineTextAlignment(.center)
            .padding(.top, subtitleSize)
            .foregroundStyle(Color.secondary)
            .aligned()

        Text(.init(title))
            .font(.system(size: titleSize, weight: .bold, design: .rounded))
            .aligned()
    }
}

@available(iOS 16.0.0, *)
struct TitleHeaderView_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            TitleHeaderView(subtitle: "Welcome to", title: "Uncover")
            AlignedTitleHeaderView(subtitle: "Welcome to", title: "Uncover")
        }
    }
}
