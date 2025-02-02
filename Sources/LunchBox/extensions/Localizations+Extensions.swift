//
//  Localizations+Extensions.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public extension View {
    /// Applies a specific language to the view's environment
    /// - Parameter language: The language to apply
    /// - Returns: A view with the specified language applied to its environment
    @available(iOS 16.0, *)
    public func withLanguage(_ language: LocalizedLanguages) -> some View {
        environment(\.locale, .init(identifier: language.identifier))
    }
}

/// Represents supported languages for localization
public enum LocalizedLanguages {
    case Japanese
    case English
    case Spanish
    case SimplifiedChinese
    case Korean
    case BrazilianPortuguese

    /// The locale identifier for the language
    /// - Returns: The string identifier used for localization
    public var identifier: String {
        switch self {
        case .Japanese:
            return "jp"
        case .English:
            return "en"
        case .Spanish:
            return "es"
        case .SimplifiedChinese:
            return "zh-Hans"
        case .Korean:
            return "ko"
        case .BrazilianPortuguese:
            return "pt-BR"
        }
    }
}
