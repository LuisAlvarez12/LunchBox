//
//  IntroScreen.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct IntroFeaturesScreen: View {
    let headerImage: String
    let appName: LocalizedStringKey
    let introRows: [IntroRow]
    let premiumHeaderImage: String
    let membershipRows: [MembershipFeatureRow]
    let onMembershipClick: () -> Void
    let onDismiss: () -> Void

    public init(headerImage: String, appName: LocalizedStringKey, introRows: [IntroRow], premiumHeaderImage: String, membershipRows: [MembershipFeatureRow], onMembershipClick: @escaping () -> Void, onDismiss: @escaping () -> Void) {
        self.headerImage = headerImage
        self.appName = appName
        self.introRows = introRows
        self.premiumHeaderImage = premiumHeaderImage
        self.membershipRows = membershipRows
        self.onMembershipClick = onMembershipClick
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack {
            Image(headerImage)
                .resizable()
                .scaledToFit()
                .frame(width: 140)
                .padding(.top, 24)

            TitleHeaderView(subtitle: "Welcome to", title: appName)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach(introRows, id: \.text) { row in
                        row
                    }

                    Image(premiumHeaderImage)
                        .resizable()
                        .frame(width: 240)
                        .scaledToFit()

                    Text("... And with **Premium**")

                    ForEach(membershipRows, id: \.feature) { row in
                        MembershipRow(membershipRow: row, forceDark: false)
                    }

                    Spacer()
                }
            }
            // todo
            .fullWidth(ipadWidth: 400)

            PrimaryButton(text: "Get Premium", action: {
                onMembershipClick()
            })

            SecondaryButton(text: "Dismiss", action: {
                onDismiss()
            })
            Spacer()
        }.full().horPadding(36)
    }
}

@available(iOS 16.0.0, *)
struct IntroFeaturesScreen_Previews: PreviewProvider {
    static var previews: some View {
        IntroFeaturesScreen(headerImage: "", appName: "Uncover", introRows: [
            IntroRow(color: Color.appPrimary, icon: "book", text: "With support for PDF, CBZ, and CBR files, Uncover aims to be your next favorite file reading app"),

            IntroRow(color: Color.appGreen, icon: "bookmark", text: "Save those favorite pages with Bookmarks and Bookmark galleries"),
            IntroRow(color: Color.appRed, icon: "lock", text: "Lock your app with a Pin and Face-ID to keep your Library private"),
            IntroRow(color: Color.appYellow, icon: "folder", text: "Organize your content in folders"),
        ], premiumHeaderImage: "", membershipRows: [
        ], onMembershipClick: {}, onDismiss: {})
    }
}

@available(iOS 16.0, *)
public struct IntroRow: View {
    let color: Color
    let icon: String
    let text: String

    public init(color: Color, icon: String, text: String) {
        self.color = color
        self.icon = icon
        self.text = text
    }

    public var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.2))
                .squareFrame(length: 40)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                }
                .springsIn(offset: 20, duration: 0.3)

            Text(.init(text))
                .font(.system(size: 16, weight: .regular, design: .default))
                .aligned()
        }.fullWidth()
    }
}
