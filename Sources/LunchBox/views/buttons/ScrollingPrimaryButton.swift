//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 5/15/24.
//

import SwiftUI

public struct ScrollingPrimaryButton: View {
    public var expanded = true
    public var title: String
    public var icon: String
    public var color: Color
    public var textColor: Color = .white

    public init(expanded: Bool = true, title: String, icon: String, color: Color, textColor: Color) {
        self.expanded = expanded
        self.title = title
        self.icon = icon
        self.color = color
        self.textColor = textColor
    }

    public var body: some View {
        HStack {
            if expanded {
                Text(title)
                    .lineLimit(1)
                    .fixedSize()
                    .bold()
            }
            Image(systemName: icon)
                .font(.title3)
                .bold()
        }
        .foregroundStyle(.white)
        .padding()
        .background {
            Capsule().fill(color.gradient)
        }
    }
}

#Preview {
    VStack {
        @State var buttonEnabled = true

        Button("toggle") {
            withAnimation {
                buttonEnabled.toggle()
            }
        }

        ScrollingPrimaryButton(expanded: buttonEnabled, title: "Add File", icon: "plus", color: .blue, textColor: .white)
    }
}
