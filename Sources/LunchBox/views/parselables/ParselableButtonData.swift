//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 2/9/24.
//

import SwiftUI

public struct ParselableButtonData {
    public let text: LocalizedStringKey
    public let systemImage: String
    public var mainColor: Color = .white
    public var activatedColor: Color = .white
    public var activatedSystemImage: String
    public let action: () async -> Bool
    
    public init(text: LocalizedStringKey, systemImage: String, mainColor: Color, activatedColor: Color, activatedSystemImage: String, action: @escaping () -> Bool) {
        self.text = text
        self.systemImage = systemImage
        self.mainColor = mainColor
        self.activatedColor = activatedColor
        self.activatedSystemImage = activatedSystemImage
        self.action = action
    }
    
    public init(text: LocalizedStringKey, systemImage: String, mainColor: Color = .white, action: @escaping () -> Bool) {
        self.text = text
        self.systemImage = systemImage
        self.mainColor = mainColor
        self.activatedColor = mainColor
        self.activatedSystemImage = systemImage
        self.action = action
    }
    
    public var menuButton: some View {
        Label(text, systemImage: systemImage)
    }
}

//
//#Preview {
//    SwiftUIView()
//}
