//
//  LabelButton.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

/// A button that displays a label with an icon and text
@available(iOS 16.0, *)
public struct LabelButton: View {
    /// The text to display in the button
    let title: LocalizedStringKey
    /// The system image name for the button's icon
    let systemImage: String
    /// The role of the button (optional)
    var role: ButtonRole? = nil
    /// The action to perform when the button is clicked
    let onClick: () -> Void

    /// Creates a new label button
    /// - Parameters:
    ///   - title: The text to display in the button
    ///   - systemImage: The system image name for the button's icon
    ///   - role: The role of the button (optional)
    ///   - onClick: The action to perform when clicked
    public init(title: LocalizedStringKey, systemImage: String, role: ButtonRole? = nil, onClick: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.onClick = onClick
    }

    public var body: some View {
        Button(role: role ?? .none, action: {
            onClick()
        }, label: {
            Label(title, systemImage: systemImage)
        }).foregroundStyle(AppThemeManager.shared.currentTheme.primary)
    }
}

/// Preview provider for the LabelButton
@available(iOS 16.0.0, *)
struct LabelButton_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            LabelButton(title: "Submit", systemImage: "chevron.down", onClick: {})
        }
    }
}
