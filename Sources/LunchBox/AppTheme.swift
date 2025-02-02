//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 10/5/24.
//

import SwiftUI
import Observation

/// Returns the current app theme scheme
public var currentAppTheme: AppThemeScheme {
    AppThemeManager.shared.currentTheme
}

/// Manager for handling the app's theme
@Observable
public class AppThemeManager {
    /// Shared instance of the theme manager
    public static var shared = AppThemeManager()
    
    /// The currently active theme scheme
    public var currentTheme = AppThemeScheme()
}

/// A view that displays a preview of color themes
public struct ColorThemeReview: View {
    /// The theme scheme to preview
    public var theme: AppThemeScheme

    /// Creates a new color theme review view
    /// - Parameter theme: The theme scheme to preview (default: AppThemeScheme())
    public init(theme: AppThemeScheme = AppThemeScheme()) {
        self.theme = theme
    }
    
    public var body: some View {
        ScrollView {
            ColorDisplay(name: "primary", color: theme.primary)
            ColorDisplay(name: "primaryContainer", color: theme.primaryContainer)
            ColorDisplay(name: "secondary", color: theme.secondary)
            ColorDisplay(name: "secondaryContainer", color: theme.secondaryContainer)
            ColorDisplay(name: "error", color: theme.error)
            ColorDisplay(name: "errorContainer", color: theme.errorContainer)
            ColorDisplay(name: "background", color: theme.background, textColor: theme.text.primary)
            
            ColorDisplay(name: "surface.normal", color: theme.surface.normal, textColor: theme.text.primary)
            ColorDisplay(name: "surface.dim", color: theme.surface.dim, textColor: theme.text.primary)
            ColorDisplay(name: "surface.Bright", color: theme.surface.Bright, textColor: theme.text.primary)
            
            ColorDisplay(name: "text.primary", color: theme.background, textColor: theme.text.primary)
            ColorDisplay(name: "text.seconary", color: theme.background, textColor: theme.text.primary)
        }
    }
}

/// Defines the color scheme for the app
public struct AppThemeScheme {
    /// Standard theme colors
    public static let LBThemePrimary = Color(UIColor(named: "lbThemePrimary", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemePrimaryContainer = Color(UIColor(named: "lbThemePrimaryContainer", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeSecondary = Color(UIColor(named: "lbThemeSecondary", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeSecondaryContainer = Color(UIColor(named: "lbThemeSecondaryContainer", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeError = Color(UIColor(named: "lbThemeError", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeErrorContainer = Color(UIColor(named: "lbThemeErrorContainer", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeBackground = Color(UIColor(named: "lbThemeBackground", in: Bundle.module, compatibleWith: nil)!)
    
    /// Primary theme color
    public var primary: Color = Self.LBThemePrimary
    /// Container color for primary elements
    public var primaryContainer: Color = Self.LBThemePrimaryContainer
    
    /// Secondary theme color
    public var secondary: Color = Self.LBThemeSecondary
    /// Container color for secondary elements
    public var secondaryContainer: Color = Self.LBThemeSecondaryContainer
    
    /// Error state color
    public var error: Color = Self.LBThemeError
    /// Container color for error states
    public var errorContainer: Color = Self.LBThemeErrorContainer
    
    /// Background color
    public var background: Color = Self.LBThemeBackground

    /// Surface color scheme
    public var surface: SurfaceScheme = SurfaceScheme()
    /// Text color scheme
    public var text: TextScheme = TextScheme()
    
    /// Creates a new app theme scheme
    /// - Parameters:
    ///   - primary: Primary theme color
    ///   - primaryContainer: Container color for primary elements
    ///   - secondary: Secondary theme color
    ///   - secondaryContainer: Container color for secondary elements
    ///   - error: Error state color
    ///   - errorContainer: Container color for error states
    ///   - background: Background color
    ///   - surface: Surface color scheme
    ///   - text: Text color scheme
    public init(primary: Color = AppThemeScheme.LBThemePrimary,
                primaryContainer: Color = AppThemeScheme.LBThemePrimaryContainer,
                secondary: Color = AppThemeScheme.LBThemeSecondary,
                secondaryContainer: Color = AppThemeScheme.LBThemeSecondaryContainer,
                error: Color = AppThemeScheme.LBThemeError,
                errorContainer: Color = AppThemeScheme.LBThemeErrorContainer,
                background: Color = AppThemeScheme.LBThemeBackground,
                surface: SurfaceScheme = SurfaceScheme(),
                text: TextScheme = TextScheme()) {
        self.primary = primary
        self.primaryContainer = primaryContainer
        self.secondary = secondary
        self.secondaryContainer = secondaryContainer
        self.error = error
        self.errorContainer = errorContainer
        self.background = background
        self.surface = surface
        self.text = text
    }
}

/// Defines the surface colors for the app
public struct SurfaceScheme {
    /// Standard surface colors
    public static let LBThemeSurfaceDim = Color(UIColor(named: "lbThemeSurfaceDim", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeSurfaceNormal = Color(UIColor(named: "lbThemeSurfaceNormal", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeSurfaceBright = Color(UIColor(named: "lbThemeSurfaceBright", in: Bundle.module, compatibleWith: nil)!)
    
    /// Dimmed surface color
    public var dim: Color = Self.LBThemeSurfaceDim
    /// Normal surface color
    public var normal: Color = Self.LBThemeSurfaceNormal
    /// Bright surface color
    public var Bright: Color = Self.LBThemeSurfaceBright
    
    /// Creates a new surface scheme
    /// - Parameters:
    ///   - dim: Dimmed surface color
    ///   - normal: Normal surface color
    ///   - Bright: Bright surface color
    public init(dim: Color = SurfaceScheme.LBThemeSurfaceDim,
                normal: Color = SurfaceScheme.LBThemeSurfaceNormal,
                Bright: Color = SurfaceScheme.LBThemeSurfaceBright) {
        self.dim = dim
        self.normal = normal
        self.Bright = Bright
    }
}

/// Defines the text colors for the app
public struct TextScheme {
    /// Standard text colors
    public static let LBThemeTextPrimary = Color(UIColor(named: "lbThemeTextPrimary", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeTextSecondary = Color(UIColor(named: "lbThemeTextSecondary", in: Bundle.module, compatibleWith: nil)!)
    
    /// Primary text color
    public var primary: Color = Self.LBThemeTextPrimary
    /// Secondary text color
    public var seconary: Color = Self.LBThemeTextSecondary
    
    /// Creates a new text scheme
    /// - Parameters:
    ///   - primary: Primary text color
    ///   - seconary: Secondary text color
    public init(primary: Color = TextScheme.LBThemeTextPrimary,
                seconary: Color = TextScheme.LBThemeTextSecondary) {
        self.primary = primary
        self.seconary = seconary
    }
}

/// A view that displays a color sample with its name
struct ColorDisplay: View {
    let name: String
    let color: Color
    var textColor: Color = .white
    
    var body: some View {
        VStack {
            Text(name).foregroundStyle(textColor)
        }.fullWidth().frame(height: 60).background(color)
    }
}
