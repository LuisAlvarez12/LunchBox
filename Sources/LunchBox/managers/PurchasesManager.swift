//
//  PurchasesManager.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import RevenueCat
import SwiftUI

@Observable
public class PurchasesManager {
    public static let shared = PurchasesManager()

    public var currentMembershipState: any SubscriptionResult = NoSubscriptionStatus()
    public var membershipPresented = false
    public var hasTrialAvailable = false

    public var preferredOffering: String? = nil

    public func showMembershipModal() {
        membershipPresented = true
    }

    private var debugOverride = false

    public func isSubscribed() -> Bool {
        if debugOverride {
            return true
        } else {
            return currentMembershipState is SubscriptionSuccess
        }
    }

    public func enableDebugOverride() {
        #if DEBUG
            debugOverride = true
        #endif
    }

    public func debugPurchaseSuccess() async {
        await updateSubscriptionState(SubscriptionSuccess(isTrial: false, subscriptionIncrement: .Annual))
    }

    public func debugPurchaseFailure() async {
        await updateSubscriptionState(SubscriptionFailure(reason: "Could Not Subscribe. Please try again later."))
    }

    public func purchase(selectedChoice: SubscriptionOptionMetadata) async -> any SubscriptionResult {
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

    private func updateSubscriptionState(_ result: any SubscriptionResult) async {
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

    public func checkCustomerStatus(acceptableEntitlements: [String]) async -> any SubscriptionResult {
        guard let customerInfo = try? await Purchases.shared.customerInfo() else {
            return SubscriptionFailure(reason: "No subscription")
        }

        var subResult: any SubscriptionResult = SubscriptionFailure(reason: "No subscription")

        acceptableEntitlements.forEach { entitlement in
            if customerInfo.entitlements.all[entitlement]?.isActive == true {
                subResult = SubscriptionSuccess(isTrial: false, subscriptionIncrement: .Weekly)
            }
        }
        await updateSubscriptionState(subResult)
        return subResult
    }

    public func restore(acceptableEntitlements: [String]) async -> any SubscriptionResult {
        do {
            let result = try await Purchases.shared.restorePurchases()

            var subResult: (any SubscriptionResult)? = nil

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

    public func restore(customerInfo: CustomerInfo, acceptableEntitlements: [String]) async -> any SubscriptionResult {
        do {
            var subResult: (any SubscriptionResult)? = nil

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

    public func testDebugHasTrialsAvailable(value: Bool) {
        debugTrials = value
    }

    private var debugTrials = false

    public func hasTrialsAvailble() async -> Bool {
        #if targetEnvironment(simulator)
            return debugTrials
        #endif
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
        hasTrialAvailable = isElligible
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

public protocol SubscriptionResult: Equatable {
    var status: String { get }
}

public struct SubscriptionSuccess: SubscriptionResult {
    public var isTrial: Bool
    public var subscriptionIncrement: SubscriptionTimeIncrement

    public let status: String = "SubscriptionSuccess"
}

public struct SubscriptionFailure: SubscriptionResult {
    public var reason: String
    public let status: String = "SubscriptionFailure"
}

public struct NoSubscriptionStatus: SubscriptionResult {
    public let status: String = "NoSubscriptionStatus"
}
