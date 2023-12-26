//
//  PurchasesManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import RevenueCat
import SwiftUI

@available(iOS 16.0, *)
public class PurchasesManager: ObservableObject {
    public static let shared = PurchasesManager()

    @Published public var currentMembershipState: SubscriptionResult = NoSubscriptionStatus()
    @Published public var membershipPresented = false
    @Published public var hasTrialAvailable = false

    public var preferredOffering: String? = nil

    public func showMembershipModal() {
        membershipPresented = true
    }

    public func isSubscribed() -> Bool {
        currentMembershipState is SubscriptionSuccess
    }

    public func debugPurchaseSuccess() async {
        await updateSubscriptionState(SubscriptionSuccess(isTrial: false, subscriptionIncrement: .Annual))
    }

    public func debugPurchaseFailure() async {
        await updateSubscriptionState(SubscriptionFailure(reason: "Could Not Subscribe. Please try again later."))
    }

    public func purchase(selectedChoice: SubscriptionOptionMetadata) async -> SubscriptionResult {
        do {
            let result = try await Purchases.shared.purchase(package: selectedChoice.package)

            if !result.userCancelled {
                let successResult = SubscriptionSuccess(isTrial: selectedChoice.eligibleForTrial, subscriptionIncrement: selectedChoice.choice)
                await updateSubscriptionState(successResult)
                return successResult
            } else {
                let failureResult = SubscriptionFailure(reason: "Could Not Subscribe. Please try again later.")
                await updateSubscriptionState(failureResult)
                return failureResult
            }
        } catch {
            let failureResult = SubscriptionFailure(reason: "Could Not Subscribe. Please try again later.")
            await updateSubscriptionState(failureResult)
            return failureResult
        }
    }

    private func updateSubscriptionState(_ result: SubscriptionResult) async {
        await MainActor.run {
            if result is SubscriptionSuccess {
                NotificationsManager.shared.showMessage("Subscription Success")
            } else if result is SubscriptionFailure {
                NotificationsManager.shared.showMessage("Could Not Subscribe. Please try again later.")
            }
            membershipPresented = false
            currentMembershipState = result
        }
    }

    public func checkCustomerStatus(acceptableEntitlements: [String]) async -> SubscriptionResult {
        guard let customerInfo = try? await Purchases.shared.customerInfo() else {
            return SubscriptionFailure(reason: "No subscription")
        }

        var subResult: SubscriptionResult = SubscriptionFailure(reason: "No subscription")

        acceptableEntitlements.forEach { entitlement in
            if customerInfo.entitlements.all[entitlement]?.isActive == true {
                subResult = SubscriptionSuccess(isTrial: false, subscriptionIncrement: .Weekly)
            }
        }
        await updateSubscriptionState(subResult)
        return subResult
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
                await updateSubscriptionState(_subResult)
                NotificationsManager.shared.showMessage("Subscription Restored!")
                return _subResult
            } else {
                let failureResult = SubscriptionFailure(reason: "Subscription not found.")
                await updateSubscriptionState(failureResult)
                return failureResult
            }
        } catch {
            let failureResult = SubscriptionFailure(reason: "Subscription not found.")
            await updateSubscriptionState(failureResult)
            return failureResult
        }
    }

    public func restore(customerInfo: CustomerInfo, acceptableEntitlements: [String]) async -> SubscriptionResult {
        do {
            var subResult: SubscriptionResult? = nil

            acceptableEntitlements.forEach { entitlement in
                if customerInfo.entitlements.all[entitlement]?.isActive == true {
                    subResult = SubscriptionSuccess(isTrial: false, subscriptionIncrement: .Weekly)
                }
            }

            if let _subResult = subResult {
                await updateSubscriptionState(_subResult)
                NotificationsManager.shared.showMessage("Subscription Restored!")
                return _subResult
            } else {
                let failureResult = SubscriptionFailure(reason: "Subscription not found.")
                await updateSubscriptionState(failureResult)
                return failureResult
            }
        } catch {
            let failureResult = SubscriptionFailure(reason: "Subscription not found.")
            await updateSubscriptionState(failureResult)
            return failureResult
        }
    }

    public func hasTrialsAvailble() async -> Bool {
        guard let offerings = try? await Purchases.shared.offerings().all else {
            return false
        }

        var fetchedPackages: [Package]?
        if let preferredOffering {
            fetchedPackages = offerings[preferredOffering]?.availablePackages
        } else {
            fetchedPackages = offerings.first?.value.availablePackages
        }

        guard let _fetchedPackages = fetchedPackages else {
            return false
        }

        var isElligible = false

        await _fetchedPackages.asyncForEach {
            let res = await Purchases.shared.checkTrialOrIntroDiscountEligibility(product: $0.storeProduct)
            if res.isEligible {
                isElligible = true
            }
        }

        return isElligible
    }

    public func getOfferings() async -> [SubscriptionOptionMetadata] {
        do {
            let offerings = try await Purchases.shared.offerings().all

            var fetchedPackages: [Package]?
            if let preferredOffering {
                fetchedPackages = offerings[preferredOffering]?.availablePackages
            } else {
                fetchedPackages = offerings.first?.value.availablePackages
            }

            guard let packages = fetchedPackages, packages.isNotEmpty else { return [] }

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

public protocol SubscriptionResult {}

public struct SubscriptionSuccess: SubscriptionResult {
    public var isTrial: Bool
    public var subscriptionIncrement: SubscriptionTimeIncrement
}

public struct SubscriptionFailure: SubscriptionResult {
    public var reason: String
}

public struct NoSubscriptionStatus: SubscriptionResult {}
