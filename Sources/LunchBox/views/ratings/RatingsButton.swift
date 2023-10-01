//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 9/20/23.
//

import StoreKit
import SwiftUI

@available(iOS 16.0, *)
public struct RatingButton<Content>: View where Content: View {
    @Environment(\.requestReview) var requestReview

    @ViewBuilder var content: () -> Content

    public init(_ content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        Button(action: {
            requestReview()
        }, label: {
            content()
        })
    }
}

@available(iOS 16.0, *)
public struct DefaultRatingsButton: View {
    var text: String
    var textColor: Color
    var bgColor: Color

    public init() {
        text = "Rate This App"
        textColor = Color.LBIdealBluePrimary
        bgColor = Color.LBIdealBlueSecondary
    }

    public init(text: String, textColor: Color, bgColor: Color) {
        self.text = text
        self.textColor = textColor
        self.bgColor = bgColor
    }

    public var body: some View {
        RatingButton {
            Label(text, systemImage: "heart.fill")
                .foregroundColor(textColor)
                .fullWidth(ipadWidth: 200)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(bgColor)
                }
                .horPadding()
        }
    }
}

@available(iOS 16.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DefaultRatingsButton()
            RatingButton {
                Text("Leave Review!!")
            }
        }
    }
}
