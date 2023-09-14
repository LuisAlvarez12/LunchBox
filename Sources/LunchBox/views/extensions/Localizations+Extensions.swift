//
//  Localizations+Extensions.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 13.0, *)
public extension View {
    @available(iOS 16.0, *)
    func withLanguage(_ language: LocalizedLanguages) -> some View {
        environment(\.locale, .init(identifier: language.identifier))
    }
}

public enum LocalizedLanguages {
    case Japanese
    case English
    case Spanish
    case SimplifiedChinese
    case Korean
    case BrazilianPortuguese

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
