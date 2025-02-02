//
//  PreviewLabel.swift
//  LunchBox
//
//  Created by Luis Alvarez on 2/2/25.
//
import SwiftUI

/// A view that wraps content in a labeled preview container
public struct PreviewLabel<Content>: View where Content: View {
    /// The text to display as the preview label
    public let previewText: String

    /// The content to display in the preview container
    @ViewBuilder var content: () -> Content

    /// Creates a new preview label view
    /// - Parameters:
    ///   - previewText: The text to display as the preview label
    ///   - content: A closure that creates the content to display
    public init(_ previewText: String, content: @escaping () -> Content) {
        self.previewText = previewText
        self.content = content
    }

    /// The body of the preview label view
    public var body: some View {
        VStack {
            Text(previewText)
                .font(.subheadline)
                .bold()
                .underline()
            VStack {
                content()
            }.frame(maxHeight: 300)
                .padding(5)
                .border(Color.blue, width: 3)
                .fullWidth()
                .padding(32)
                .background(RoundedRectangle(cornerRadius: 20).fill(Material.thick))
        }
    }
}
