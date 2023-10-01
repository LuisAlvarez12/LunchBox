//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 9/19/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(value: "112") { str in
            PinView(input: str, onPinComplete: { _ in

            }, textColor: Color.red, hidesPin: false, currentEmoji: nil, onClearEmoji: {})
        }
    }
}
