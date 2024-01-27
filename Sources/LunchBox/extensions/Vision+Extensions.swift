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

public enum OrnamentCompatibleAnchor {
    case leading
    case trailing
    case bottom
    case top
    
    @available(visionOS 1.0, *)
    public var anchor: OrnamentAttachmentAnchor {
        switch self {
        case .leading:
                .scene(.leading)
        case .trailing:
                .scene(.trailing)
        case .bottom:
                .scene(.bottom)
        case .top:
                .scene(.top)
        }
    }
}

public extension View {
    func lunchboxOrnament<Content>(visibility: Visibility = .automatic, attachmentAnchor: OrnamentCompatibleAnchor, contentAlignment: Alignment = .center, @ViewBuilder ornament: () -> Content) -> some View where Content: View {
        #if os(visionOS)
        self.ornament(visibility: visibility, attachmentAnchor: attachmentAnchor.anchor, contentAlignment: contentAlignment, ornament: ornament)
        #else
            self
        #endif
    }
}
