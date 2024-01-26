//
//  NoticeView.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct IconProperties {
    public var size: CGFloat = 100
    public var background: Color?
    public var backgroundGradient: Bool = false
    public var iconColor: Color

    public init(size: CGFloat, background: Color? = nil, backgroundGradient: Bool = false, iconColor: Color = LunchboxThemeManager.shared.currentColor) {
        self.size = size
        self.background = background
        self.backgroundGradient = backgroundGradient
        self.iconColor = iconColor
    }
}

@available(iOS 16.0, *)
public struct NoticeView: View {
    @Environment(\.colorScheme) var colorScheme

    let image: ParselableImage
    let title: LocalizedStringKey
    var bodyText: LocalizedStringKey? = nil

    var iconProperties = IconProperties(size: 120)

    public init(image: ParselableImage, title: LocalizedStringKey, bodyText: LocalizedStringKey? = nil, iconProperties: IconProperties = IconProperties(size: 140)) {
        self.image = image
        self.title = title
        self.bodyText = bodyText
        self.iconProperties = iconProperties
    }

    public var body: some View {
        VStack {
            Spacer()
            if let _iconProp = iconProperties.background {
                image.createImage(widthFrame: iconProperties.size + 30, frame: iconProperties.size, color: iconProperties.iconColor)
                    .background(content: {
                        if iconProperties.backgroundGradient {
                            Circle().foregroundStyle(_iconProp.gradient)
                        } else {
                            Circle().foregroundStyle(_iconProp)
                        }
                    })
            } else {
                image.createImage(frame: iconProperties.size, color: iconProperties.iconColor)
            }

            Text(title).font(.system(size: 18, weight: .bold, design: .default))
                .foregroundColor(Color.LBMonoScreenOffTone)
                .multilineTextAlignment(.center)

            if let bodyText {
                Text(bodyText)
                    .font(.system(size: 16, weight: .light, design: .rounded)).multilineTextAlignment(.center).horPadding().padding(.top, 8)
            }
            Spacer()
            Spacer()
            Spacer()
        }.padding()
    }
}

@available(iOS 16.0, *)
#Preview {
    ScrollView(.vertical) {
        NoticeView(image: ParselableImage(assetImage: "folder"), title: "Search throughout your specific Cabin for files, folders, links, etc.", bodyText: "Not to worry! askfl; kadsf asdkf;kasd l;kfl;asl;fk l;asdkfl;asdkdf 'asd;lkdf ;laskd l;fkasl;' dfkl;ask;df kasiop jdfio").full()
    }
}
