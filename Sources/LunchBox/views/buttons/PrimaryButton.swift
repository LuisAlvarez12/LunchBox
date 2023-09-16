//
//  PrimaryButton.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct PrimaryButton: View {
    let text: LocalizedStringKey
    let color: Color
    let action: () -> Void
    var disabled: Bool = false

    public init(text: LocalizedStringKey, color: Color = Color.LBIdealBluePrimary, disabled: Bool = false, action: @escaping () -> Void) {
        self.text = text
        self.color = color
        self.action = action
        self.disabled = disabled
    }

    public var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(text)
                .foregroundStyle(.white)
                .font(.system(size: 18, weight: .medium, design: .default))
                .fullWidth()
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(disabled ? Color.secondary : color))
        })
        .disabled(disabled)
        .horPadding()
    }
}

@available(iOS 16.0, *)
struct PrimaryButton_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButton(text: "Dismiss", action: {})
        }
    }
}
