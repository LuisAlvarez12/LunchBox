//
//  MembershipOption.swift
//  
//
//  Created by Luis Alvarez on 9/16/23.
//

import SwiftUI
import RevenueCat

public enum SubscriptionTimeIncrement {
    case Annual
    case Monthly
    case Lifetime
    case Weekly

    public static func getType(identifier: String) -> SubscriptionTimeIncrement? {
        if identifier.localizedCaseInsensitiveContains("monthly") {
            return .Monthly
        }
        if identifier.localizedCaseInsensitiveContains("annual") {
            return .Annual
        }
        if identifier.localizedCaseInsensitiveContains("lifetime") {
            return .Lifetime
        }
        if identifier.localizedCaseInsensitiveContains("weekly") {
            return .Weekly
        }
        return nil
    }
}

@available(iOS 13.0, *)
public extension SubscriptionTimeIncrement {
    public func getLocalizedBundle() -> MembershipLocalizedBundle {
        switch self {
        case .Annual:
            return MembershipLocalizedBundle(title: "Annual", desc: nil, badge: nil)
        case .Monthly:
            return MembershipLocalizedBundle(title: "Monthly", desc: nil, badge: nil)
        case .Lifetime:
            return MembershipLocalizedBundle(title: "Lifetime", desc: nil, badge: "Limited Time Sale!")
        case .Weekly:
            return MembershipLocalizedBundle(title: "Weekly", desc: nil, badge: nil)
        }
    }
}

@available(iOS 13.0, *)
public protocol SubscriptionMetadata {
    var choice: SubscriptionTimeIncrement { get }
    var localizedBundle: MembershipLocalizedBundle { get }
    var eligibleForTrial: Bool { get }
}


@available(iOS 13.0, *)
struct InternalSubscriptionMetadata : SubscriptionMetadata {
    var choice: SubscriptionTimeIncrement
    let localizedBundle: MembershipLocalizedBundle
    var eligibleForTrial: Bool = false
    var fakePrice = "$1000"
    
    public func getConfirmationString() -> String {
        switch choice {
        case .Annual:
            if eligibleForTrial {
                return "3 Days Free, then plan renews automatically for \(fakePrice)/year until cancelled"
            } else {
                return "Plan renews automatically for \(fakePrice)/year until cancelled"
            }
        case .Monthly:
            if eligibleForTrial {
                return "3 Days Free, then plan renews automatically for \(fakePrice)/month until cancelled"
            } else {
                return "Plan renews automatically for \(fakePrice)/month until cancelled"
            }
        case .Lifetime:
            if eligibleForTrial {
                return "One time purchase of \(fakePrice)"
            } else {
                return "One time purchase of \(fakePrice)"
            }
        case .Weekly:
            if eligibleForTrial {
                return "3 Days Free, then plan renews automatically for \(fakePrice)/week until cancelled"
            } else {
                return "Plan renews automatically for \(fakePrice)/week until cancelled"
            }
        }
    }
}

@available(iOS 13.0, *)
public struct SubscriptionOptionMetadata : SubscriptionMetadata {
    
    public var choice: SubscriptionTimeIncrement
    public let product: StoreProduct
    public let package: Package
    public let localizedBundle: MembershipLocalizedBundle
    public var eligibleForTrial: Bool = false

    public func getConfirmationString() -> String {
        switch choice {
        case .Annual:
            if eligibleForTrial {
                return "3 Days Free, then plan renews automatically for \(product.localizedPriceString)/year until cancelled"
            } else {
                return "Plan renews automatically for \(product.localizedPriceString)/year until cancelled"
            }
        case .Monthly:
            if eligibleForTrial {
                return "3 Days Free, then plan renews automatically for \(product.localizedPriceString)/month until cancelled"
            } else {
                return "Plan renews automatically for \(product.localizedPriceString)/month until cancelled"
            }
        case .Lifetime:
            if eligibleForTrial {
                return "One time purchase of \(product.localizedPriceString)"
            } else {
                return "One time purchase of \(product.localizedPriceString)"
            }
        case .Weekly:
            if eligibleForTrial {
                return "3 Days Free, then plan renews automatically for \(product.localizedPriceString)/week until cancelled"
            } else {
                return "Plan renews automatically for \(product.localizedPriceString)/week until cancelled"
            }
        }
    }
}

@available(iOS 13.0, *)
public struct MembershipLocalizedBundle {
    let title: LocalizedStringKey
    var desc: LocalizedStringKey? = nil
    var badge: LocalizedStringKey? = nil
}

@available(iOS 13.0, *)
public extension Package {
    func createMembershipChoice() async -> SubscriptionOptionMetadata? {
        let identifier = storeProduct.productIdentifier
        guard let choice = SubscriptionTimeIncrement.getType(identifier: identifier) else {
            return nil
        }

        let isEligibleForTrial = await Purchases.shared.checkTrialOrIntroDiscountEligibility(product: storeProduct)
        let isEligible = isEligibleForTrial == .eligible

        let bundle = choice.getLocalizedBundle()

        return SubscriptionOptionMetadata(choice: choice, product: storeProduct, package: self, localizedBundle: bundle, eligibleForTrial: isEligible)
    }
}

@available(iOS 16.0, *)
public struct MembershipOption: View {
    let option: SubscriptionMetadata

    var isSelected = false
    
    public init(option: SubscriptionMetadata, isSelected: Bool = false) {
        self.option = option
        self.isSelected = isSelected
    }

    @ViewBuilder
    public var body: some View {
        if let _option = option as? SubscriptionOptionMetadata {
            OptionView(title: _option.localizedBundle.title, bodyText: _option.localizedBundle.desc, badge: _option.localizedBundle.badge, price: _option.product.localizedPriceString, isSelected: isSelected)
        } else {
            OptionView(title: option.localizedBundle.title, bodyText: option.localizedBundle.desc, badge: option.localizedBundle.badge, price: "$1000.00", isSelected: isSelected)
        }
    }
}
