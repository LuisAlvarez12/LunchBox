//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 12/26/23.
//

import SwiftUI

public struct PillButton: View {
    public let text: LocalizedStringKey
    public let image: ParselableImage
    
    public var body: some View {
        Label(title: {
            Text(text)
                .foregroundStyle(Color.LBMonoScreenOffTone)
        }, icon: {
            image.createImage(frame: 18)
        })
        .font(.footnote)
        .bold()
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background{
            RoundedRectangle(cornerRadius: 8).foregroundStyle(Color.systemSecondary)
        }
    }
}

#Preview {
    PillButton(text: "Favorites", image: ParselableImage(systemImage: ParselableSystemImage(systemImage: "folder", color: Color.green)))
}

