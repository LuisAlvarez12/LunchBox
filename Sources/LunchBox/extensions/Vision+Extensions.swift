//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 1/25/24.
//

import SwiftUI

public extension Color {
    
    public func visionable(_ visionColor: Color? = nil) -> Color {
        #if os(visionOS)
        return visionColor ?? Color.white
        #else
        return self
        #endif
    }
}


