//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 5/15/24.
//

import SwiftUI

/// A primary button that can expand and collapse in a scrolling view
public struct ScrollingPrimaryButton: View {
    /// Whether the button is expanded to show text
    public var expanded = true
    /// The title text to display when expanded
    public var title: String
    /// The system image name for the button's icon
    public var icon: String
    /// The background color of the button
    public var color: Color
    /// The color of the button's text and icon
    public var textColor: Color = .white

    /// Creates a new scrolling primary button
    /// - Parameters:
    ///   - expanded: Whether the button is expanded to show text
    ///   - title: The title text to display when expanded
    ///   - icon: The system image name for the button's icon
    ///   - color: The background color of the button
    ///   - textColor: The color of the button's text and icon
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
