//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 1/25/24.
//

import SwiftUI

public extension Color {
    func visionable(_ visionColor: Color? = nil) -> Color {
        #if os(visionOS)
            return visionColor ?? Color.white
        #else
            return self
        #endif
    }

    func visionableClear() -> Color {
        visionable(Color.clear)
    }
}

public extension View {
    func lunchboxOrnament<Content>(visibility: Visibility = .automatic, attachmentAnchor: OrnamentAttachmentAnchor, contentAlignment: Alignment = .center, @ViewBuilder ornament: () -> Content) -> some View where Content: View {
        #if os(visionOS)
            self.ornament(visibility: visibility, attachmentAnchor: attachmentAnchor, contentAlignment: contentAlignment, ornament: ornament)
        #else
            self
        #endif
    }
}
