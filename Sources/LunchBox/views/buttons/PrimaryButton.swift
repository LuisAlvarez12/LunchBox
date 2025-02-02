//
//  PrimaryButton.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

/// A primary styled button with customizable appearance
@available(iOS 16.0, *)
public struct PrimaryButton: View {
    /// The text to display on the button
    let text: LocalizedStringKey
    /// The button's background color
    let color: Color
    /// The action to perform when clicked
    let action: () -> Void
    /// Whether the button is disabled
    var disabled: Bool = false

    /// Creates a new primary button
    /// - Parameters:
    ///   - text: The text to display on the button
    ///   - color: The button's background color
    ///   - disabled: Whether the button is disabled
    ///   - action: The action to perform when clicked
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

/// A primary styled button that handles asynchronous actions
@available(iOS 16.0, *)
public struct AsyncPrimaryButton: View {
    /// The text to display on the button
    let text: LocalizedStringKey
    /// The button's background color
    let color: Color
    /// The asynchronous action to perform
    var action: () async -> Void
    /// Whether the button is disabled
    var disabled: Bool = false

    /// Creates a new async primary button
    /// - Parameters:
    ///   - text: The text to display on the button
    ///   - color: The button's background color
    ///   - disabled: Whether the button is disabled
    ///   - action: The asynchronous action to perform
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

/// Preview provider for the primary buttons
@available(iOS 16.0, *)
struct PrimaryButton_PreviewProvider: PreviewProvider {
    static var previews: some View {
        return VStack {
            PrimaryButton(text: "Dismiss", action: {})
            AsyncPrimaryButton(text: "Dismiss", action: {})
        }
    }
}
