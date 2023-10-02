//
//  PremiumView.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct PremiumView: View {
    var showCrown = false

    public init(showCrown: Bool = false) {
        self.showCrown = showCrown
    }

    public var body: some View {
        HStack(spacing: 0) {
            Group {
                if showCrown {
                    Image(systemName: "crown.fill")
                } else {
                    Image(systemName: "laurel.leading")
                    Text("Premium")
                    Image(systemName: "laurel.trailing")
                }
            }
        }
    }
}

public struct PremiumViewButton: View {
    @ObservedObject var purchasesMagager = PurchasesManager.shared
    
    var showCrown = false

    public init(showCrown: Bool = false) {
        self.showCrown = showCrown
    }

    @ViewBuilder
    public var body: some View {
        Button(action: {
            if !purchasesMagager.isSubscribed() {
                purchasesMagager.showMembershipModal()
            }
        }, label: {
            if purchasesMagager.isSubscribed() {
                EmptyView()
            } else {
                PremiumView(showCrown: showCrown)
            }
        })
    }
}

@available(iOS 16.0.0, *)
struct PremiumView_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            PremiumView()
                .foregroundStyle(.blue)
            PremiumView(showCrown: true)
                .foregroundStyle(.red)
        }
    }
}
