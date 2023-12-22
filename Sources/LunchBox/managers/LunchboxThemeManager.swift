//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 12/22/23.
//

import SwiftUI

public class LunchboxThemeManager {
    public static var shared = LunchboxThemeManager()
    
    public var currentColor: Color = Color.LBIdealBluePrimary
    
    public func setColor(_ color: Color) {
        currentColor = color
    }
}
