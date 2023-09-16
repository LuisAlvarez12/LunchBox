//
//  PremiumView.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct PremiumView: View {
    
    public var body: some View {
        HStack(spacing: 0) {
            Group {
                Image(systemName: "laurel.leading")
                Text("Premium")
                Image(systemName: "laurel.trailing")
            }
        }
    }
}

@available(iOS 16.0.0, *)
struct PremiumView_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            PremiumView()
                .foregroundStyle(.blue)
            PremiumView()
                .foregroundStyle(.red)
        }
    }
}
