//
//  MembershipOption.swift
//  
//
//  Created by Luis Alvarez on 9/16/23.
//

import SwiftUI
import RevenueCat

@available(iOS 16.0, *)
struct MembershipOption: View {
    let option: NewMembershipOption

    var isSelected = false

    var body: some View {
        OptionView(title: option.localizedBundle.title, bodyText: option.localizedBundle.desc, badge: option.localizedBundle.badge, price: option.product.localizedPriceString, isSelected: isSelected)
    }
}

enum MembershipChoice {
    case Annual
    case Monthly
    case Lifetime
    case Weekly

    static func getType(identifier: String) -> MembershipChoice? {
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
extension MembershipChoice {
    func getLocalizedBundle() -> MembershipLocalizedBundle {
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
struct MembershipLocalizedBundle {
    let title: LocalizedStringKey
    var desc: LocalizedStringKey? = nil
    var badge: LocalizedStringKey? = nil
}

@available(iOS 13.0, *)
struct NewMembershipOption {
    let choice: MembershipChoice
    let product: StoreProduct
    let package: Package
    let localizedBundle: MembershipLocalizedBundle
    var eligibleForTrial: Bool = false

    func getConfirmationString() -> String {
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
extension Package {
    func createMembershipChoice() async -> NewMembershipOption? {
        let identifier = storeProduct.productIdentifier
        guard let choice = MembershipChoice.getType(identifier: identifier) else {
            return nil
        }

        let isEligibleForTrial = await Purchases.shared.checkTrialOrIntroDiscountEligibility(product: storeProduct)
        let isEligible = isEligibleForTrial == .eligible

        let bundle = choice.getLocalizedBundle()

        return NewMembershipOption(choice: choice, product: storeProduct, package: self, localizedBundle: bundle, eligibleForTrial: isEligible)
    }
}

