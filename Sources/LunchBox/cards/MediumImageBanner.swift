//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 5/20/24.
//

import SwiftUI

struct MediumImageBanner: View {
    
    let image: ParselableImage
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    
    var body: some View {
        VStack {
            image
            .createImage(frame: .infinity)
            .cornerRadius(20, corners: .allCorners)
            
            Text(title).font(.subheadline).bold().aligned()
            Text(subtitle).foregroundStyle(.secondary).font(.footnote).aligned()
        }
    }
}

#Preview {
    VStack{
        HStack{
            MediumImageBanner(image: ParselableImage(parentName: "Uncover", assetName: "icon-woman-reading", systemImage: "book"), title: "Get Premium", subtitle: "Read all of your files, and uncover new features")
            MediumImageBanner(image: ParselableImage(parentName: "Uncover", assetName: "icon-woman-reading", systemImage: "book"), title: "Get Premium", subtitle: "Read all of your files, and uncover new features")
        }
    }
}
