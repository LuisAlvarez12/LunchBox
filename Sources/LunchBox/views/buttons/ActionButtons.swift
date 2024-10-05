//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 10/1/23.
//

import SwiftUI

@available(iOS 16.0, *)
public extension View {
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

@available(iOS 16.0, *)
public enum ActionBottomBarType {
    case Horizontal
    case Vertical
}

@available(iOS 16.0, *)
public struct BottomBarHorizontalModifier: ViewModifier {
    var type: ActionBottomBarType = .Horizontal
    var primaryText: LocalizedStringKey = "Continue"
    var secondaryText: LocalizedStringKey = "Skip"
    var primaryDisabled: Bool
    var secondaryTransparent: Bool
    var secondaryDisabled: Bool = false
    let onPrimaryEnabledClick: () -> Void
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
