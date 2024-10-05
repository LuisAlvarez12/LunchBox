//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 10/5/24.
//

import SwiftUI
import Observation

@Observable
public class AppThemeManager {
    public static var shared = AppThemeManager()
    
    public var currentTheme = AppThemeScheme()
}

#Preview(body: {
    VStack {
        ColorThemeReview()
    }
})

public struct ColorThemeReview : View {
    public var theme: AppThemeScheme

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

public struct AppThemeScheme {
    public static let LBThemePrimary = Color(UIColor(named: "lbThemePrimary", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemePrimaryContainer = Color(UIColor(named: "lbThemePrimaryContainer", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeSecondary = Color(UIColor(named: "lbThemeSecondary", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeSecondaryContainer = Color(UIColor(named: "lbThemeSecondaryContainer", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeError = Color(UIColor(named: "lbThemeError", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeErrorContainer = Color(UIColor(named: "lbThemeErrorContainer", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeBackground = Color(UIColor(named: "lbThemeBackground", in: Bundle.module, compatibleWith: nil)!)
    
    public var primary: Color = Self.LBThemePrimary
    public var primaryContainer: Color = Self.LBThemePrimaryContainer
    
    public var secondary: Color = Self.LBThemeSecondary
    public var secondaryContainer: Color = Self.LBThemeSecondaryContainer
    
    public var error: Color = Self.LBThemeError
    public var errorContainer: Color = Self.LBThemeErrorContainer
    
    public  var background: Color = Self.LBThemeBackground

    public var surface: SurfaceScheme = SurfaceScheme()
    public var text: TextScheme = TextScheme()
    
    public init(primary: Color = AppThemeScheme.LBThemePrimary, primaryContainer: Color = AppThemeScheme.LBThemePrimaryContainer, secondary: Color = AppThemeScheme.LBThemeSecondary, secondaryContainer: Color = AppThemeScheme.LBThemeSecondaryContainer, error: Color = AppThemeScheme.LBThemeError, errorContainer: Color = AppThemeScheme.LBThemeErrorContainer, background: Color = AppThemeScheme.LBThemeBackground, surface: SurfaceScheme = SurfaceScheme(), text: TextScheme = TextScheme()) {
        
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

public struct SurfaceScheme {
    public static let LBThemeSurfaceDim = Color(UIColor(named: "lbThemeSurfaceDim", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeSurfaceNormal = Color(UIColor(named: "lbThemeSurfaceNormal", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeSurfaceBright = Color(UIColor(named: "lbThemeSurfaceBright", in: Bundle.module, compatibleWith: nil)!)
    
    public var dim: Color = Self.LBThemeSurfaceDim
    public var normal: Color  = Self.LBThemeSurfaceNormal
    public var Bright: Color  = Self.LBThemeSurfaceBright
    
    public init(dim: Color = SurfaceScheme.LBThemeSurfaceDim, normal: Color  = SurfaceScheme.LBThemeSurfaceNormal, Bright: Color  = SurfaceScheme.LBThemeSurfaceBright) {
        self.dim = dim
        self.normal = normal
        self.Bright = Bright
    }
}

public struct TextScheme {
    public static let LBThemeTextPrimary = Color(UIColor(named: "lbThemeTextPrimary", in: Bundle.module, compatibleWith: nil)!)
    public static let LBThemeTextSecondary = Color(UIColor(named: "lbThemeTextSecondary", in: Bundle.module, compatibleWith: nil)!)
    
    public  var primary: Color  = Self.LBThemeTextPrimary
    public var seconary: Color  = Self.LBThemeTextSecondary
    
    public init(primary: Color = TextScheme.LBThemeTextPrimary, seconary: Color  = TextScheme.LBThemeTextSecondary) {
        self.primary = primary
        self.seconary = seconary
    }
}


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
