//
//  Color+Extensions.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

@available(iOS 15.0, *)
public extension Color {
    static let systemSecondary = Color(uiColor: UIColor.secondarySystemBackground)

    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

public extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

// extension ColorScheme {
//    func getColor() -> Color {
//        self == .dark ? Color.clear : Color.themeColor()
//    }
// }

@available(iOS 16.0, *)
public extension Color {
    init(hex: String) {
        
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static var random: Color {
        return Color(
            red: .random(in: 0 ... 1),
            green: .random(in: 0 ... 1),
            blue: .random(in: 0 ... 1)
        )
    }

    var components: (r: Double, g: Double, b: Double, a: Double) {
        #if canImport(UIKit)
            typealias NativeColor = UIColor
        #elseif canImport(AppKit)
            typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else { return (0, 0, 0, 0) }

        return (Double(r), Double(g), Double(b), Double(a))
    }

    // Sheets
    static let sheetBackgroundReverse = Color("sheet-background-reverse")
    static let trueBackground = Color("background")
    static let trueBackgroundReverse = Color("tone-screen")
    static let whiteLightOffBlackDark = Color("whiteOnLight-offBlackOnDark")

    // Share sheet
    static let shareSheetBackground = Color("share-sheet-background")
    static let shareSheetAccent = Color("share-sheet-accents")

    static let systemBackground = Color(.systemGroupedBackground)

    // Assets
    static let mellowYellow = Color("mellow-yellow")

    // Onboarding
    static let onboardingBlue = Color("onboarding-intro")
    static let onboardingName = Color("onboarding-name")
    static let onboardingEmoji = Color("onboarding-emoji")
    static let onboardingPin = Color("onboarding-pin")
    static let onboardingSummary = Color("onboarding-summary")
    static let onboardingSuccess = Color("onboarding-success")

    static let offBlack = Color("offblack")
    static let offBlackAccent = Color("offblack-accent")

    static let offWhite = Color("off-white")

    static let toneWhite = Color("tone-white")
    static let screenTone = Color("tone")

    static let trueToneBackground = Color("true-tone-background")

    // Error
    static let deepRed = Color("deep-red")

    // Favoriting
    static let favoriteYellow = Color("favorite-yellow")

    // Blue theme
//    static let blueThemeDark = Color("blue-theme-dark")
//    static let blueThemeLight = Color("blue-theme-light")

    static let blueThemeDark = Color.appPrimary
    static let blueThemeLight = Color.appPrimary

    static let appPrimary = Color.blue

//    static let appPrimary = Color(hex: "09A8EF")
    static let appSecondary = Color(hex: "C1E9FB")

    static let appGreen = Color(hex: "00BD96")
    static let appYellow = Color(hex: "FFD077")
    static let appRed = Color(hex: "FF8589")
}
