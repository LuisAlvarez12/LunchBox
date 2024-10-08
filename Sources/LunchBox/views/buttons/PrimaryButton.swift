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

    public init(text: LocalizedStringKey, color: Color = AppThemeManager.shared.currentTheme.primary, disabled: Bool = false, action: @escaping () -> Void) {
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
                .font(.system(size: 18, weight: .semibold, design: .default))
            #if os(iOS)
                .fullWidth()
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(disabled ? Color.secondary : color))
            #else
                .horPadding(42)
                .vertPadding(16)
            #endif
        })
        .disabled(disabled)
        .horPadding()
    }
}

@available(iOS 16.0, *)
public struct AsyncPrimaryButton: View {
    let text: LocalizedStringKey
    let color: Color
    var action: () async -> Void
    var disabled: Bool = false

    public init(text: LocalizedStringKey, color: Color = AppThemeManager.shared.currentTheme.primary, disabled: Bool = false, action: @escaping () async -> Void) {
        self.text = text
        self.color = color
        self.action = action
        self.disabled = disabled
    }

    public var body: some View {
        AsyncButton(action: {
            await action()
        }, label: {
            Text(text)
                .foregroundStyle(.white)
                .font(.system(size: 18, weight: .semibold, design: .default))
            #if os(iOS)
                .fullWidth()
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(disabled ? Color.secondary : color))
            #else
                .horPadding(42)
                .vertPadding(16)
            #endif
        })
        .disabled(disabled)
        .horPadding()
    }
}

@available(iOS 16.0, *)
struct PrimaryButton_PreviewProvider: PreviewProvider {
    static var previews: some View {
        
        return VStack {
            PrimaryButton(text: "Dismiss", action: {})
            AsyncPrimaryButton(text: "Dismiss", action: {})
        }
    }
}
