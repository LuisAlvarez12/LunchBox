//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 10/1/23.
//

import SwiftUI

/// Adds action buttons to a view
@available(iOS 16.0, *)
public extension View {
    /// Adds horizontal or vertical action buttons to a view
    /// - Parameters:
    ///   - type: The layout type of the action buttons (horizontal or vertical)
    ///   - primaryText: The text for the primary button
    ///   - secondaryText: The text for the secondary button
    ///   - primaryDisabled: Whether the primary button is disabled
    ///   - secondaryDisabled: Whether the secondary button is disabled
    ///   - secondaryTransparent: Whether the secondary button should be transparent
    ///   - onPrimaryEnabledClick: Action to perform when the primary button is clicked
    ///   - onSecondaryEnabledClick: Action to perform when the secondary button is clicked
    /// - Returns: A view with action buttons added
    func withActionButtons(
        type: ActionBottomBarType = .Horizontal,
        primaryText: LocalizedStringKey = "Continue",
        secondaryText: LocalizedStringKey = "Skip",
        primaryDisabled: Bool,
        secondaryDisabled: Bool = false,
        secondaryTransparent: Bool = true,
        onPrimaryEnabledClick: @escaping () -> Void,
        onSecondaryEnabledClick: @escaping () -> Void
    ) -> some View {
        modifier(BottomBarHorizontalModifier(type: type, primaryText: primaryText, secondaryText: secondaryText, primaryDisabled: primaryDisabled, secondaryTransparent: secondaryTransparent, secondaryDisabled: secondaryDisabled, onPrimaryEnabledClick: onPrimaryEnabledClick, onSecondaryEnabledClick: onSecondaryEnabledClick))
    }
}

/// The layout type for action buttons
@available(iOS 16.0, *)
public enum ActionBottomBarType {
    /// Buttons arranged horizontally
    case Horizontal
    /// Buttons arranged vertically
    case Vertical
}

/// A view modifier that adds action buttons to the bottom of a view
@available(iOS 16.0, *)
public struct BottomBarHorizontalModifier: ViewModifier {
    /// The layout type of the buttons
    var type: ActionBottomBarType = .Horizontal
    /// Text for the primary button
    var primaryText: LocalizedStringKey = "Continue"
    /// Text for the secondary button
    var secondaryText: LocalizedStringKey = "Skip"
    /// Whether the primary button is disabled
    var primaryDisabled: Bool
    /// Whether the secondary button should be transparent
    var secondaryTransparent: Bool
    /// Whether the secondary button is disabled
    var secondaryDisabled: Bool = false
    /// Action to perform when the primary button is clicked
    let onPrimaryEnabledClick: () -> Void
    /// Action to perform when the secondary button is clicked
    let onSecondaryEnabledClick: () -> Void

    public func body(content: Content) -> some View {
        #if os(visionOS)
            content
                .ornament(visibility: .visible, attachmentAnchor: .scene(.bottom), ornament: {
                    HStack {
                        Button(primaryText, action: {
                            onPrimaryEnabledClick()
                        })
                        .tint(.blue)
                        .disabled(primaryDisabled)

                        Divider().horPadding()

                        Button(secondaryText, action: {
                            onSecondaryEnabledClick()
                        })

                        .disabled(secondaryDisabled)
                    }.padding(8)
                        .glassBackgroundEffect()

                })
        #else
            content.overlay(alignment: .bottom, content: {
                if type == .Horizontal {
                    HStack(alignment: .center) {
                        PrimaryButton(text: primaryText, disabled: primaryDisabled, action: {
                            onPrimaryEnabledClick()
                        })

                        Button(action: {
                            onSecondaryEnabledClick()
                        }, label: {
                            Text(secondaryText)
                                .foregroundStyle(AppThemeManager.shared.currentTheme.primary)
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .padding()
                                .background(Capsule().fill(Color.systemSecondary))
                        }).padding(.trailing)
                    }.padding().background {
                        LinearGradient(colors: [AppThemeManager.shared.currentTheme.background, Color.clear], startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.bottom)
                    }
                } else {
                    VStack(alignment: .center) {
                        PrimaryButton(text: primaryText, disabled: primaryDisabled, action: {
                            onPrimaryEnabledClick()
                        })

                        if secondaryTransparent {
                            Button(action: {
                                onSecondaryEnabledClick()
                            }, label: {
                                Text(secondaryText)
                                    .foregroundStyle(AppThemeManager.shared.currentTheme.primary)
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .padding(8)
                            })
                        } else {
                            SecondaryButton(text: secondaryText, action: {
                                onSecondaryEnabledClick()
                            })
                        }

                    }.padding().background {
                        LinearGradient(colors: [Color.LBMonoSchemeTone, Color.LBMonoSchemeTone.opacity(0.6), Color.clear], startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.bottom)
                    }
                }
            })
        #endif
    }
}

#Preview {
    VStack {
        Rectangle().fill(Material.thin).withActionButtons(type: .Vertical, primaryDisabled: false, secondaryTransparent: false, onPrimaryEnabledClick: {}, onSecondaryEnabledClick: {})
    }
}

#Preview {
    VStack {
        Rectangle().fill(Material.thin).withActionButtons(primaryDisabled: false, onPrimaryEnabledClick: {}, onSecondaryEnabledClick: {})
    }
}
