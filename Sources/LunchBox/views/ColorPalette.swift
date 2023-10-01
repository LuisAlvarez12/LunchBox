//
//  ColorPalette.swift
//
//
//  Created by Luis Alvarez on 9/16/23.
//

import SwiftUI

@available(iOS 16.0, *)
private struct TestColorPalette: View {
    @available(iOS 16.0, *)
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Color.lunchBoxColors, id: \.self) { c in
                    Circle().foregroundStyle(c).squareFrame(length: 50)
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct TestColorPalette_Preview: PreviewProvider {
    static var previews: some View {
        TestColorPalette()
    }
}
