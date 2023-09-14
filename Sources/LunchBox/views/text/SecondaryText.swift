//
//  SecondaryText.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct SecondaryText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text).font(.footnote).foregroundColor(.secondary).aligned()
    }
}

@available(iOS 16.0.0, *)
struct Test_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VStack {
                SecondaryText("This is secondary Text")
            }.full().background(Color.white).preferredColorScheme(.light)
            VStack {
                SecondaryText("This is secondary Text")
            }.full().background(Color.black.ignoresSafeArea()).preferredColorScheme(.dark)
        }.full()
    }
}
