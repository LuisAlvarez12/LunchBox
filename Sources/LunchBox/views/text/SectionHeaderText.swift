//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 10/4/23.
//

import SwiftUI

public struct SectionHeaderText: View {
    
    public let text: String
    
    public var body: some View {
        Text(text).font(.system(size: 12, weight: .heavy, design: .default))
            .textCase(.uppercase)
            .foregroundColor(Color.secondary)
            .aligned()
    }
}

#Preview {
    SectionHeaderText(text: "Test")
}
