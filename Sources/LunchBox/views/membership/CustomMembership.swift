//
//  MembershipContainerScreen.swift
//
//
//  Created by Luis Alvarez on 9/16/23.
//

import RevenueCatUI
import SwiftUI

@available(iOS 16.0, *)
public struct SubscriptionScreenContainer<Content: View>: View {
    let purchasesManager = PurchasesManager.shared

    let membershipMetaData: MembershipMetaData

    @State var subscriptionOptions: [SubscriptionMetadata] = []

    @State var selectedChoice: SubscriptionMetadata? = nil
    
    @ViewBuilder var content: () -> Content

    var screen: some View {
        content()
    }
        
    public var body: some View {
        ViewThatFits {
            screen.paywallFooter(purchaseCompleted: { customerInfo in
                Task {
                    _ = await purchasesManager.restore(customerInfo: customerInfo, acceptableEntitlements: membershipMetaData.acceptedEntitlements)
                }
            }, restoreCompleted: { customerInfo in
                Task {
                    _ = await purchasesManager.restore(customerInfo: customerInfo, acceptableEntitlements: membershipMetaData.acceptedEntitlements)
                }
            })
            ScrollView {
                screen
            }.paywallFooter(purchaseCompleted: { customerInfo in
                Task {
                    _ = await purchasesManager.restore(customerInfo: customerInfo, acceptableEntitlements: membershipMetaData.acceptedEntitlements)
                }
            }, restoreCompleted: { customerInfo in
                Task {
                    _ = await purchasesManager.restore(customerInfo: customerInfo, acceptableEntitlements: membershipMetaData.acceptedEntitlements)
                }
            })
        }
        .task {
            if subscriptionOptions.isEmpty {
                subscriptionOptions = await purchasesManager.getOfferings()
            }
        }
    }
}
