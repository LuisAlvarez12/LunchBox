//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 12/22/23.
//

import SwiftUI

public class LunchboxThemeManager: ObservableObject {
    public static var shared = LunchboxThemeManager()
    
    public var currentColor: Color = LunchboxThemeManager.shared.currentColor
    
    public func setColor(_ color: Color) {
        currentColor = color
    }
}
