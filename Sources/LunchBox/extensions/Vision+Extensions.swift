//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 1/25/24.
//

import SwiftUI

public extension Color {
    /// Returns a color adapted for visionOS or the original color for other platforms
    /// - Parameter visionColor: Optional color to use specifically for visionOS
    /// - Returns: The adapted color for the current platform
    public func visionable(_ visionColor: Color? = nil) -> Color {
        #if os(visionOS)
            return visionColor ?? Color.white
        #else
            return self
        #endif
    }

    /// Returns a clear color for visionOS or the original color for other platforms
    /// - Returns: The adapted color for the current platform
    public func visionableClear() -> Color {
        visionable(Color.clear)
    }
}

/// Represents compatible anchor points for ornaments across different platforms
public enum OrnamentCompatibleAnchor {
    case leading
    case trailing
    case bottom
    case top

    #if os(visionOS)
    /// Converts the compatible anchor to a visionOS-specific ornament attachment anchor
    /// - Returns: The corresponding OrnamentAttachmentAnchor for visionOS
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
    #endif
}

public extension View {
    /// Adds an ornament to the view with platform-specific behavior
    /// - Parameters:
    ///   - visibility: The visibility of the ornament
    ///   - attachmentAnchor: The anchor point for the ornament
    ///   - contentAlignment: The alignment of the ornament's content
    ///   - ornament: A closure that creates the ornament content
    /// - Returns: A view with the ornament attached
    public func lunchboxOrnament<Content>(visibility: Visibility = .automatic, attachmentAnchor: OrnamentCompatibleAnchor, contentAlignment: Alignment = .center, @ViewBuilder ornament: () -> Content) -> some View where Content: View {
        #if os(visionOS)
            self.ornament(visibility: visibility, attachmentAnchor: attachmentAnchor.anchor, contentAlignment: contentAlignment, ornament: ornament)
        #else
            self
        #endif
    }
}
