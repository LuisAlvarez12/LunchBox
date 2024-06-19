//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 6/19/24.
//

import SwiftUI

public struct VerticalButton: View {
    public let image: String
    public let text: LocalizedStringKey
    public var style: VerticalButtonStyle = .Bordered
    public let onClick: () -> Void

    public init(image: String, text: LocalizedStringKey, style: VerticalButtonStyle = .Bordered, onClick: @escaping () -> Void) {
        self.image = image
        self.text = text
        self.style = style
        self.onClick = onClick
    }

    @ViewBuilder
    public var body: some View {
        if style == .Bordered {
            Button(action: {
                HapticsManager.shared.onGeneral()
                onClick()
            }, label: {
                VStack {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .squareFrame(length: 24)
                        .foregroundStyle(Color.LBMonoScreenOffTone)
                    Text(text)
                        .font(.footnote)
                        .lineLimit(1, reservesSpace: true)
                        .bold()
                        .foregroundStyle(Color.LBMonoScreenOffTone)
                        .padding(.top, 2)
                }.padding(12)
                    .fullWidth().background(RoundedRectangle(cornerRadius: 12).fill(Material.thin))
                    .contentShape(.hoverEffect, .rect(cornerRadius: 12))
                    .hoverEffect()
            })
            .buttonStyle(.plain)
        } else {
            Button(action: {
                onClick()
            }, label: {
                VStack {
                    Image(systemName: image).font(.system(size: 22, weight: .light, design: .rounded))
                        .squareFrame(length: 24)

                    Text(text).font(.system(size: 12, weight: .semibold, design: .default))
                        .lineLimit(2, reservesSpace: true)
                        .frame(minWidth: 32)
                        .padding(.top, 2)
                }
            })
            .buttonStyle(.plain)
            .foregroundStyle(Color.LBMonoScreenOffTone)
        }
    }
}

public enum VerticalButtonStyle {
    case Bordered
    case Simple
}

#Preview {
    VStack {
        VerticalButton(image: "folder", text: "This is a test", style: .Simple, onClick: {})
        VerticalButton(image: "folder.fill", text: "This is a test", style: .Bordered, onClick: {})
    }
}
