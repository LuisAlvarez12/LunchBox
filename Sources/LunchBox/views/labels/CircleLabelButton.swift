//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 1/25/24.
//

import SwiftUI

public struct CircleLabelButton : View {
    public let text: LocalizedStringKey
    public let image: String
    public let action: () -> Void
    
    public init(_ text: LocalizedStringKey, image: String, _ action: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action()
        }, label: {
            Label(text, systemImage: image)
                .labelStyle(.iconOnly)
        })
    }
}

#Preview {
    CircleLabelButton("Test", image: "plus") {
        
    }
}
