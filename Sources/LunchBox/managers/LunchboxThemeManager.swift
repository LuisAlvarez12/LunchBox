//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 12/22/23.
//

import SwiftUI

class LunchboxThemeManager: ObservableObject {
    static var shared = LunchboxThemeManager()
    
    var currentColor: Color = Color.LBIdealBluePrimary
    
    func setColor(_ color: Color) {
        currentColor = color
    }
}
