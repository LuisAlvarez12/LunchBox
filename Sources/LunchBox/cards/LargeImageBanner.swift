//
//  SwiftUIView 2.swift
//  
//
//  Created by Luis Alvarez on 5/20/24.
//

import SwiftUI

struct LargeImageBanner: View {
    
    let image: ParselableImage
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    var titleColor: Color = .blue
    
    var body: some View {
        image
            .createImage(frame: .infinity)
            .overlay(alignment: .bottom) {
                VStack(alignment: .leading){
                    Text(title).font(.title2).bold().foregroundStyle(titleColor.gradient).aligned()
                    Text(subtitle).font(.footnote)
                }.fullWidth().padding().background(Material.thin)
            }
            .cornerRadius(20, corners: .allCorners)
    }
}


#Preview {
    ScrollView {
                LargeImageBanner(image: ParselableImage(parentName: "Uncover", assetName: "icon-woman-reading", systemImage: "book"), title: "Get Premium", subtitle: "Read all of your files, and uncover new features")
    }
}
