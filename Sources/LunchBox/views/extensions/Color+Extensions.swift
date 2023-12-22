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

@available(iOS 16.0, *)
public extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

@available(iOS 16.0, *)
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

    static let lunchBoxColors = [
        Color.LBMonoScreenOffTone,
        Color.LBMonoSchemeTone,
        Color.LBMonoSheetBackground,
        Color.LBMonoSheetAccent,
        Color.LBUtilityErrorRed,
        Color.LBUtilityBrightYellow,
        LunchboxThemeManager.shared.currentColor,
        Color.LBIdealBlueSecondary,
    ]
    
    // Banner
    static let LBBannerDarkPurple = Color(UIColor(named: "banner-dark-purple", in: Bundle.module, compatibleWith: nil)!)
    static let LBBannerGreen = Color(UIColor(named: "banner-green", in: Bundle.module, compatibleWith: nil)!)
    static let LBBannerOffBlack = Color(UIColor(named: "banner-offblack", in: Bundle.module, compatibleWith: nil)!)
    static let LBBannerOffWhite = Color(UIColor(named: "banner-offwhite", in: Bundle.module, compatibleWith: nil)!)
    static let LBBannerPink = Color(UIColor(named: "banner-pink", in: Bundle.module, compatibleWith: nil)!)
    static let LBBannerRed = Color(UIColor(named: "banner-red", in: Bundle.module, compatibleWith: nil)!)
    static let LBBannerYellow = Color(UIColor(named: "banner-yellow", in: Bundle.module, compatibleWith: nil)!)
    static let LBBannerLimeGreen = Color(UIColor(named: "banner-lime-green", in: Bundle.module, compatibleWith: nil)!)


    // Mono
    static let LBMonoScreenOffTone = Color(UIColor(named: "lightOffBlackDarkOffWhite", in: Bundle.module, compatibleWith: nil)!)
    static let LBMonoSchemeTone = Color(UIColor(named: "lightWhiteDarkBlack", in: Bundle.module, compatibleWith: nil)!)
    static let LBMonoSheetBackground = Color(UIColor(named: "sheet-background", in: Bundle.module, compatibleWith: nil)!)
    static let LBMonoSheetAccent = Color(UIColor(named: "sheet-background-reverse", in: Bundle.module, compatibleWith: nil)!)

    // Utils
    static let LBUtilityErrorRed = Color(UIColor(named: "deep-red", in: Bundle.module, compatibleWith: nil)!)
    static let LBUtilityBrightYellow = Color(UIColor(named: "favorite-yellow", in: Bundle.module, compatibleWith: nil)!)

    // Palette
    static let LBIdealBluePrimary = Color(UIColor(named: "idealBluePrimary", in: Bundle.module, compatibleWith: nil)!)
    static let LBIdealBlueSecondary = Color(UIColor(named: "idealBlueSecondary", in: Bundle.module, compatibleWith: nil)!)
}
