//
//  NoticeView.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct IconProperties {
    var size: CGFloat = 100
    var background: Color? = nil
    var backgroundGradient: Bool = true
}

@available(iOS 16.0, *)
public struct NoticeView: View {
    @Environment(\.colorScheme) var colorScheme

    let image: String
    let title: LocalizedStringKey
    var bodyText: LocalizedStringKey? = nil
    
    var iconProperties = IconProperties(size: 100)

    public init(image: String, title: LocalizedStringKey, bodyText: LocalizedStringKey? = nil) {
        self.image = image
        self.title = title
        self.bodyText = bodyText
    }
    
    public init(image: String, title: LocalizedStringKey, bodyText: LocalizedStringKey? = nil, iconProperties: IconProperties) {
        self.image = image
        self.title = title
        self.bodyText = bodyText
        self.iconProperties = iconProperties
    }

    public var body: some View {
        VStack {
            Spacer()
            if let _iconProp =  iconProperties.background {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconProperties.size)
                    .background(content: {
                        if iconProperties.backgroundGradient {
                            Circle().foregroundStyle( _iconProp.gradient)
                        } else {
                            Circle().foregroundStyle( _iconProp)
                        }
                    })
            } else {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconProperties.size)
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
struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView(image: "icon-viewer-empty", title: "Search throughout your specific Cabin for files, folders, links, etc.", bodyText: "Not to worry! askfl; kadsf asdkf;kasd l;kfl;asl;fk l;asdkfl;asdkdf 'asd;lkdf ;laskd l;fkasl;' dfkl;ask;df kasiop jdfio").full()
    }
}
