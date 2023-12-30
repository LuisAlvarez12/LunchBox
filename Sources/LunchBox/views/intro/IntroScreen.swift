//
//  IntroScreen.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct IntroFeaturesScreen: View {
    let headerImage: ParselableImage
    let appName: LocalizedStringKey
    let introRows: [IntroRow]
    let premiumHeaderImage: ParselableImage
    let membershipRows: [MembershipFeatureRow]
    let onMembershipClick: () -> Void
    let onSecondaryText: LocalizedStringKey
    let onDismiss: () -> Void

    var imageSize: CGFloat

    public init(headerImage: ParselableImage, imageSize: CGFloat = 50, appName: LocalizedStringKey, introRows: [IntroRow], premiumHeaderImage: ParselableImage, membershipRows: [MembershipFeatureRow], onMembershipClick: @escaping () -> Void, onSecondaryText: LocalizedStringKey = "Dismiss", onDismiss: @escaping () -> Void) {
        self.headerImage = headerImage
        self.imageSize = imageSize
        self.appName = appName
        self.introRows = introRows
        self.premiumHeaderImage = premiumHeaderImage
        self.membershipRows = membershipRows
        self.onMembershipClick = onMembershipClick
        self.onSecondaryText = onSecondaryText
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                Spacer().frame(height: 50)
                VStack {
                    
                    VStack(spacing: 0){
                        Text("Welcome to")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.secondary)
                        
                        HStack(spacing: 4){
                            headerImage.createImage(frame: 50)
                            Text(appName)
                                .font(.system(size: 40, weight: .bold, design: .default))
                                .fontWidth(.condensed)
                                .lineLimit(1)
                        }
                    }.fullWidth()

                    ForEach(introRows, id: \.text) { row in
                        row
                    }

                    premiumHeaderImage.createImage(widthFrame: 100, frame: 100)
                        .padding(.top)

                    Text("... And with **Premium**")

                    ForEach(membershipRows, id: \.feature) { row in
                        MembershipRow(membershipRow: row, forceDark: false)
                    }

                    Spacer()
                }

                Spacer().frame(height: 250)
            }
            .fullWidth(ipadWidth: 400)
            .withActionButtons(type: .Vertical, primaryText: PurchasesManager.shared.hasTrialAvailable ? "Redeem Free Trial" : "Premium" , secondaryText: "Continue", primaryDisabled: false, secondaryDisabled: false, secondaryTransparent: false, onPrimaryEnabledClick: {
                onMembershipClick()
            }, onSecondaryEnabledClick: {
                onDismiss()
            })

            // todo

//            PrimaryButton(text: "Get Premium", action: {
//
//            })
//
//            SecondaryButton(text: onSecondaryText, action: {
//                onDismiss()
//            })

            Spacer()
        }.full().horPadding(36).background(Color.LBMonoSchemeTone)
    }
}

@available(iOS 16.0.0, *)
struct IntroFeaturesScreen_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.clear
        }.full().sheet(isPresented: .constant(true)) {
            IntroFeaturesScreen(headerImage: ParselableImage(parentName: "Cabinit", assetName: "icon-folder-main-icon", sizeVariant: 3, systemImage: "lock.fill"), appName: "Cabinit", introRows: [
                IntroRow(color: Color.blue, icon: "book", text: "With support for PDF, CBZ, and CBR files, Uncover aims to be your next favorite file reading app"),

                IntroRow(color: Color.red, icon: "bookmark", text: "Save those favorite pages with Bookmarks and Bookmark galleries"),
                IntroRow(color: Color.blue, icon: "lock", text: "Lock your app with a Pin and Face-ID to keep your Library private"),
                IntroRow(color: Color.blue, icon: "folder", text: "Organize your content in folders"),
            ], premiumHeaderImage: ParselableImage(parentName: "Premium", assetName: "icon-crown", sizeVariant: 3, systemImage: "lock.fill"), membershipRows: TestFeatureRow.membershipRowItems,
            onMembershipClick: {}, onSecondaryText: "Test", onDismiss: {})
        }
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

private struct TestFeatureRow: MembershipFeatureRow {
    var feature: String
    let icon: String
    let featureName: LocalizedStringKey
    let description: LocalizedStringKey
    var color: Color

    static let membershipRowItems = [
        TestFeatureRow(feature: "0", icon: "house", featureName: "More Folders", description: "Keep your content organized and seperate from other Folders. You can still directly share content to them too!", color: Color.blue),
        TestFeatureRow(feature: "1", icon: "play", featureName: "Audio and Video Playback", description: "Play Supported audio and video files from within the app.", color: Color.red),
        TestFeatureRow(feature: "2", icon: "book", featureName: "Read PDFs", description: "Read Supported PDFs directly from your Cabin", color: Color.purple),
        TestFeatureRow(feature: "3", icon: "infinity", featureName: "No file Limits", description: "Use your local storage to its full capacity and exceed the standard file limit.", color: Color.yellow),
    ]
}
