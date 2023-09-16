//
//  LabelButton.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct LabelButton: View {
    let title: LocalizedStringKey
    let systemImage: String
    var role: ButtonRole? = nil
    let onClick: () -> Void

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
        }).foregroundStyle(Color.LBIdealBluePrimary)
    }
}

@available(iOS 16.0.0, *)
struct LabelButton_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            LabelButton(title: "Submit", systemImage: "chevron.down", onClick: {})
        }
    }
}
