//
//  Text+Extensions.swift
//  
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 13.0, *)
extension Text {
    func semiBold() -> Text {
        fontWeight(.semibold)
    }

    func roundFont(_ size: CGFloat = 18, weight: Font.Weight = .regular) -> Text {
        font(.system(size: size, weight: weight, design: .rounded))
    }
}

@available(iOS 13.0, *)
struct TextExtensions_PreviewProvider : PreviewProvider {
    static var previews: some View {
        VStack{
            Text(GenericFaker.paragraph).semiBold()
            Text(GenericFaker.paragraph).roundFont()
        }
    }
}
