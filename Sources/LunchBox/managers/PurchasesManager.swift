//
//  PurchasesManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI
import RevenueCat

public protocol SubscriptionResult {
    
}

public struct SubscriptionSuccess: SubscriptionResult {
    public var isTrial: Bool
    public var subscriptionIncrement: SubscriptionTimeIncrement
}

public struct SubscriptionFailure: SubscriptionResult {
    public var reason: String
}

@available(iOS 16.0, *)
public class PurchasesManager: ObservableObject {
    
    public static let shared = PurchasesManager()
    
    public func purchase(selectedChoice: SubscriptionOptionMetadata) async -> SubscriptionResult{
        do {
            let result = try await Purchases.shared.purchase(package: selectedChoice.package)
            
            if !result.userCancelled {
                return SubscriptionSuccess(isTrial: selectedChoice.eligibleForTrial, subscriptionIncrement: selectedChoice.choice)
            } else {
                await MainActor.run {
                    //                    AppManager.shared.membershipPresented = false
                    NotificationsManager.shared.showMessage("Could Not Subscribe. Please try again later.")
                }
                return SubscriptionFailure(reason: "")
            }
        } catch {
            return SubscriptionFailure(reason: "")
        }
    }
    
    public func restore(acceptableEntitlements: [String]) async -> SubscriptionResult {
        do {
            let result = try await Purchases.shared.restorePurchases()
            
            var subResult: SubscriptionResult? = nil
            
            acceptableEntitlements.forEach { entitlement in
                if result.entitlements.all[entitlement]?.isActive == true {
                    
                    subResult = SubscriptionSuccess(isTrial: false, subscriptionIncrement: .Weekly)
                }
            }
            
            if let _subResult = subResult {
                NotificationsManager.shared.showMessage("Subscription Restored!")
                return _subResult
            }
            
            NotificationsManager.shared.showMessage("Subscription not found.")
            return SubscriptionFailure(reason: "Subscription not found.")
        } catch {
            NotificationsManager.shared.showMessage("We hit a snag.")
            return SubscriptionFailure(reason: "We hit an issue")
        }
    }
    
    public func getOfferings() async -> [SubscriptionOptionMetadata] {
        do {
            guard let packages = try await Purchases.shared.offerings().all.first?.value.availablePackages else { return [] }
            
            let choices = await packages.mapAsync(task: {
                await $0.createMembershipChoice()
            }).compactMap { $0 }
            
            return choices
        } catch {
            // handle error
            print(error.localizedDescription)
            return []
        }
    }
}
