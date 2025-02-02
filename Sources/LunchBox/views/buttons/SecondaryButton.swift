//
//  SecondaryButton.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

/// A secondary styled button that handles asynchronous actions
@available(iOS 16.0, *)
public struct AsyncSecondaryButton: View {
    /// The text to display on the button
    let text: LocalizedStringKey
    /// The button's text color
    let color: Color
    /// The asynchronous action to perform
    var action: () async -> Void
    /// Whether the button background should be transparent
    var transparent = false
    /// Whether the button is disabled
    var disabled: Bool = false

    /// Creates a new async secondary button
    /// - Parameters:
    ///   - text: The text to display on the button
    ///   - color: The button's text color
    ///   - transparent: Whether the button background should be transparent
    ///   - disabled: Whether the button is disabled
    ///   - action: The asynchronous action to perform
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

/// A secondary styled button
@available(iOS 16.0, *)
public struct SecondaryButton: View {
    /// The text to display on the button
    let text: LocalizedStringKey
    /// The button's text color
    let color: Color
    /// The action to perform when clicked
    let action: () -> Void
    /// Whether the button background should be transparent
    var transparent = false
    /// Whether the button is disabled
    var disabled: Bool = false

    /// Creates a new secondary button
    /// - Parameters:
    ///   - text: The text to display on the button
    ///   - color: The button's text color
    ///   - transparent: Whether the button background should be transparent
    ///   - disabled: Whether the button is disabled
    ///   - action: The action to perform when clicked
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

/// Preview provider for the secondary buttons
@available(iOS 16.0.0, *)
struct SecondaryButton_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            SecondaryButton(text: "Dismiss", action: {})
            AsyncSecondaryButton(text: "Dismiss", action: {})
        }
    }
}
