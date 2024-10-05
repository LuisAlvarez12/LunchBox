//
//  SecondaryButton.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct AsyncSecondaryButton: View {
    let text: LocalizedStringKey
    let color: Color
    var action: () async -> Void
    var transparent = false
    var disabled: Bool = false

    public init(text: LocalizedStringKey, color: Color = AppThemeManager.shared.currentTheme.primary, transparent: Bool = false, disabled: Bool = false, action: @escaping () async -> Void) {
        self.text = text
        self.color = color
        self.action = action
        self.disabled = disabled
        self.transparent = transparent
    }

    public var body: some View {
        AsyncButton(action: {
            await action()
        }, label: {
            Text(text)
                .foregroundStyle(disabled ? Color.secondary : color)
                .font(.system(size: 18, weight: .medium, design: .default))
            #if os(iOS)
                .fullWidth()
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(transparent ? Color.clear : Color.systemSecondary))
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
public struct SecondaryButton: View {
    let text: LocalizedStringKey
    let color: Color
    let action: () -> Void
    var transparent = false
    var disabled: Bool = false

    public init(text: LocalizedStringKey, color: Color = AppThemeManager.shared.currentTheme.primary, transparent: Bool = false, disabled: Bool = false, action: @escaping () -> Void) {
        self.text = text
        self.color = color
        self.action = action
        self.disabled = disabled
        self.transparent = transparent
    }

    public var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(text)
                .foregroundStyle(disabled ? Color.secondary : color)
                .font(.system(size: 18, weight: .medium, design: .default))
            #if os(iOS)
                .fullWidth()
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(transparent ? Color.clear : Color.systemSecondary))
            #else
                .horPadding(42)
                .vertPadding(16)
            #endif
        })
        .disabled(disabled)
        .horPadding()
    }
}

@available(iOS 16.0.0, *)
struct SecondaryButton_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            SecondaryButton(text: "Dismiss", action: {})
            AsyncSecondaryButton(text: "Dismiss", action: {})
        }
    }
}
