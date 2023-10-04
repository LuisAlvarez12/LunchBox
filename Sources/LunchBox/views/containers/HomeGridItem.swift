//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 10/4/23.
//

import SwiftUI

public struct HomeGridItem: View {
    public let image: ParselableImage
    public let text: String
    
    public init(image: ParselableImage, text: String) {
        self.image = image
        self.text = text
    }

    public var body: some View {
        VStack {
            image.createImage(frame: 46, color: Color.LBIdealBluePrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(UIColor.secondarySystemBackground))
                )

            Text(text)
                .font(.footnote)
                .foregroundStyle(Color.LBMonoScreenOffTone)
        }
    }
}

#Preview {
    HomeGridItem(image: ParselableImage(systemImage: "folder"), text: "Test")
}
