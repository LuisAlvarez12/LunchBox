//
//  OptionView.swift
//
//
//  Created by Luis Alvarez on 9/16/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct OptionView: View {
    let title: LocalizedStringKey
    var bodyText: LocalizedStringKey? = nil
    var badge: LocalizedStringKey? = nil
    let price: String

    var isSelected = false

    var body: some View {
        HStack {
            if isSelected {
                Circle()
                    .foregroundStyle(Color.green)
                    .squareFrame(length: 20)
                    .overlay {
                        Image(systemName: "checkmark")
                            .resizable()
                            .bold()
                            .foregroundStyle(.white)
                            .padding(4)
                    }
            } else {
                Circle()
                    .foregroundStyle(Color.secondary)
                    .squareFrame(length: 20)
            }

            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.LBMonoScreenOffTone)

                if let desc = bodyText {
                    Text(desc)
                        .font(.footnote)
                        .foregroundStyle(Color.LBMonoScreenOffTone)
                        .multilineTextAlignment(.leading)
                }

            }.padding(.leading, 4)

            Spacer()

            VStack {
                Text(price).bold()
                    .foregroundStyle(Color.LBMonoScreenOffTone)
            }
        }.padding().background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.systemSecondary)
                .overlay {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green.gradient, lineWidth: 3)
                    }
                }
        }.horPadding()
            .vertPadding(8)
            .overlay(alignment: .topTrailing, content: {
                if let _badge = badge {
                    Text(_badge)
                        .foregroundStyle(Color.white)
                        .font(.caption)
                        .bold()
                        .horPadding()
                        .background(Capsule().fill(Color.green.gradient))
                        .padding(.trailing, 24)
                }
            })
    }
}

@available(iOS 16.0, *)
struct OptionView_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            OptionView(title: "Annual", bodyText: "Great Offer!", badge: "Limited Time", price: "1.99", isSelected: true)
            OptionView(title: "Annual", bodyText: nil, badge: "Limited Time", price: "1.99", isSelected: false)
            OptionView(title: "Annual", bodyText: "Great Offer!", badge: "Limited Time", price: "1.99", isSelected: true)
        }
    }
}
