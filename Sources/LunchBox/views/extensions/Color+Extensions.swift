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
extension Color {
  
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

extension UIColor {
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
        @available(iOS 13.0, *)
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

    var name: String {
        switch self {
        case Color.themeBlue1: return "theme-blue-1"
        case Color.themeBlue2: return "theme-blue-2"
        case Color.themeBlue: return "theme-blue"
        case Color.themeGold1: return "theme-gold-1"
        case Color.themeGreen1: return "theme-green-1"
        case Color.themeOlive: return "theme-olive"
        case Color.themeOrange2: return "theme-orange-2"
        case Color.themePink1: return "theme-pink-1"
        case Color.themePink2: return "theme-pink-2"
        case Color.themePink: return "theme-pink"
        case Color.themePurple1: return "theme-purple-1"
        case Color.themePurple: return "theme-purple"
        case Color.themeRed: return "theme-red"
        case Color.themeSalmon1: return "theme-salmon-1"
        case Color.themeSalmon: return "theme-salmon"
        case Color.themeTurqoise: return "theme-turqoise"
        case Color.themeYellow1: return "theme-yellow-1"
        case Color.themeBlue3: return "theme-blue-3"
        case Color.themeOrange1: return "theme-orange-1"
        case Color.themeRed2: return "theme-red-2"
        case Color.themeMint1: return "theme-mint-1"
        case Color.themePurple3: return "theme-purple-3"
        case Color.themeOrange3: return "theme-orange-3"
        case Color.themePink4: return "theme-pink-4"
        case Color.themeRed3: return "theme-red-3"
        case Color.themePink5: return "theme-pink-5"
        default: return "blue"
        }
    }

    static func fromName(colorName: String?) -> Color {
        switch colorName {
        case "theme-blue-1": return Color.themeBlue1
        case "theme-blue-2": return Color.themeBlue2
        case "theme-blue": return Color.themeBlue
        case "theme-gold-1": return Color.themeGold1
        case "theme-green-1": return Color.themeGreen1
        case "theme-olive": return Color.themeOlive
        case "theme-orange-2": return Color.themeOrange2
        case "theme-pink-1": return Color.themePink1
        case "theme-pink-2": return Color.themePink2
        case "theme-pink": return Color.themePink
        case "theme-purple-1": return Color.themePurple1
        case "theme-purple": return Color.themePurple
        case "theme-red": return Color.themeRed
        case "theme-salmon-1": return Color.themeSalmon1
        case "theme-salmon": return Color.themeSalmon
        case "theme-turqoise": return Color.themeTurqoise
        case "theme-yellow-1": return Color.themeYellow1
        case "theme-blue-3": return Color.themeBlue3
        case "theme-orange-1": return Color.themeOrange1
        case "theme-red-2": return Color.themeRed2
        case "theme-mint-1": return Color.themeMint1
        case "theme-purple-3": return Color.themePurple3
        case "theme-orange-3": return Color.themeOrange3
        case "theme-pink-4": return Color.themePink4
        case "theme-red-3": return Color.themeRed3
        case "theme-pink-5": return Color.themePink5
        default: return Color.appPrimary
        }
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

    // theme
    static let themeBlue1 = Color("theme-blue-1")
    static let themeBlue2 = Color("theme-blue-2")
    static let themeBlue = Color("theme-blue")
    static let themeGold1 = Color("theme-gold-1")
    static let themeGreen1 = Color("theme-green-1")
    static let themeOlive = Color("theme-olive")
    static let themeOrange2 = Color("theme-orange-2")
    static let themePink1 = Color("theme-pink-1")
    static let themePink2 = Color("theme-pink-2")
    static let themePink = Color("theme-pink")
    static let themePurple1 = Color("theme-purple-1")
    static let themePurple = Color("theme-purple")
    static let themeRed = Color("theme-red")
    static let themeSalmon1 = Color("theme-salmon-1")
    static let themeSalmon = Color("theme-salmon")
    static let themeTurqoise = Color("theme-turqoise")
    static let themeYellow1 = Color("theme-yellow-1")

    // MVP 1.0
    static let themeBlue3 = Color("theme-blue-3")
    static let themeOrange1 = Color("theme-orange-1")
    static let themeRed2 = Color("theme-red-2")
    static let themeMint1 = Color("theme-mint-1")
    static let themePurple3 = Color("theme-purple-3")
    static let themeOrange3 = Color("theme-orange-3")
    static let themePink4 = Color("theme-pink-4")
    static let themeRed3 = Color("theme-red-3")
    static let themePink5 = Color("theme-pink-5")

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

