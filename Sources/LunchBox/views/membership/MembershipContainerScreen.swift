//
//  MembershipContainerScreen.swift
//
//
//  Created by Luis Alvarez on 9/16/23.
//

import SwiftUI
import RevenueCatUI

@available(iOS 16.0, *)
public struct LocalizedKeyWithPosition {
    let id: Int
    let feature: LocalizedStringKey

    public init(id: Int, feature: LocalizedStringKey) {
        self.id = id
        self.feature = feature
    }
}

@available(iOS 16.0, *)
public struct MembershipMetaData {
    let appName: String
    // Premium, plus, etc
    let appMembershipName: String
    let acceptedEntitlements: [String]
    let heroImageAsset: String
    let primaryMembershipColor: Color
    let features: [LocalizedStringKey]
    let onSubscribeSuccess: () -> Void
    let onSubscribeFailure: () -> Void

    public init(appName: String, appMembershipName: String, acceptedEntitlements: [String], heroImageAsset: String, primaryMembershipColor: Color, features: [LocalizedStringKey], onSubscribeSuccess: @escaping () -> Void, onSubscribeFailure: @escaping () -> Void) {
        self.appName = appName
        self.appMembershipName = appMembershipName
        self.acceptedEntitlements = acceptedEntitlements
        self.heroImageAsset = heroImageAsset
        self.primaryMembershipColor = primaryMembershipColor
        self.features = features
        self.onSubscribeSuccess = onSubscribeSuccess
        self.onSubscribeFailure = onSubscribeFailure
    }
}

@available(iOS 16.0, *)
public struct MembershipContainerScreen: View {
    let purchasesManager = PurchasesManager.shared

    let membershipMetaData: MembershipMetaData
    let membershipFeatures: [LocalizedKeyWithPosition]

    @State var subscriptionOptions: [SubscriptionMetadata] = []

    @State var selectedChoice: SubscriptionMetadata? = nil

    public init(membershipMetaData: MembershipMetaData) {
        let keys: [LocalizedKeyWithPosition] = membershipMetaData.features.enumerated().map { index, element in
            LocalizedKeyWithPosition(id: index, feature: element)
        }

        self.membershipMetaData = membershipMetaData
        membershipFeatures = keys
    }

    init(membershipMetaData: MembershipMetaData, subscriptionOptions: [SubscriptionMetadata]) {
        let keys: [LocalizedKeyWithPosition] = membershipMetaData.features.enumerated().map { index, element in
            LocalizedKeyWithPosition(id: index, feature: element)
        }

        self.membershipMetaData = membershipMetaData
        membershipFeatures = keys
        self.subscriptionOptions = subscriptionOptions
    }

    public var screen: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Image(membershipMetaData.heroImageAsset)
                        .resizable()
                        .scaledToFit()
                        .squareFrame(length: 100)
                    Spacer()
                }.padding(.top, 24)

                Text("Unlock the Full \(membershipMetaData.appName) Experience")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .bold()
                    .lineLimit(3)
                    .horPadding()
                    .padding(.bottom, 4)

                VStack(alignment: .leading) {
                    ForEach(membershipFeatures, id: \.id) { item in
                        Label(title: {
                            Text(item.feature)
                        }, icon: {
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundStyle(membershipMetaData.primaryMembershipColor.gradient)
                                .bold()
                        })
                    }
                }
            }
        }
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
//        .overlay(alignment: .topTrailing) {
//            Button(action: {
//                Task {
//                    await PurchasesManager.shared.debugPurchaseSuccess()
//                    await MainActor.run {
//                        membershipMetaData.onSubscribeSuccess()
//                    }
//                }
//            }, label: {
//                Image(systemName: "checkmark.circle.fill")
//            })
//        }
//        .overlay(alignment: .topLeading) {
//            Button(action: {
//                Task {
//                    await PurchasesManager.shared.debugPurchaseFailure()
//                    await MainActor.run {
//                        membershipMetaData.onSubscribeFailure()
//                    }
//                }
//            }, label: {
//                Image(systemName: "xmark.app.fill")
//            })
//        }
        .background(Color.LBMonoSchemeTone)
        .task {
            if subscriptionOptions.isEmpty {
                subscriptionOptions = await purchasesManager.getOfferings()
            }
        }
    }
}

@available(iOS 16.0, *)
struct MembershipContainerScreen_PreviewProvider: PreviewProvider {
    static var previews: some View {
        MembershipContainerScreen(
            membershipMetaData: MembershipMetaData(
                appName: "Cabinit",
                appMembershipName: "Plus",
                acceptedEntitlements: [""],
                heroImageAsset: "",
                primaryMembershipColor: LunchboxThemeManager.shared.currentColor,
                features: [
                    "Multiple Cabins",
                    "Audio and Video Playback",
                    "Read Supported Book Files",
                    "No File Limits",
                    "Face ID",
                    "Emergency Wipe",
                ],
                onSubscribeSuccess: {},
                onSubscribeFailure: {}
            ),
            subscriptionOptions: [
                InternalSubscriptionMetadata(choice: SubscriptionTimeIncrement.Weekly, localizedBundle: MembershipLocalizedBundle(title: "Weekly"), eligibleForTrial: false),
                InternalSubscriptionMetadata(choice: SubscriptionTimeIncrement.Monthly, localizedBundle: MembershipLocalizedBundle(title: "Monthly"), eligibleForTrial: false),
                InternalSubscriptionMetadata(choice: SubscriptionTimeIncrement.Annual, localizedBundle: MembershipLocalizedBundle(title: "Annual"), eligibleForTrial: true),
            ]
        )
        //        .asSheetPreview()
    }
}

@available(iOS 16.0, *)
extension View {
    func asSheetPreview() -> some View {
        modifier(SheetPreviewModifier())
    }
}

@available(iOS 16.0, *)
struct SheetPreviewModifier: ViewModifier {
    @State var presented = false

    func body(content _: Content) -> some View {
        VStack {
            Color.white
        }.sheet(isPresented: $presented, content: {
            MembershipContainerScreen(
                membershipMetaData: MembershipMetaData(
                    appName: "Cabinit",
                    appMembershipName: "Plus",
                    acceptedEntitlements: [""],
                    heroImageAsset: "",
                    primaryMembershipColor: .red,
                    features: [
                        "Multiple Cabins",
                        "Audio and Video Playback",
                        "Read Supported Book Files",
                        "No File Limits",
                        "Face ID",
                        "Emergency Wipe",
                    ],
                    onSubscribeSuccess: {},
                    onSubscribeFailure: {}
                ),
                subscriptionOptions: [
                    InternalSubscriptionMetadata(choice: SubscriptionTimeIncrement.Weekly, localizedBundle: MembershipLocalizedBundle(title: "Weekly"), eligibleForTrial: true),
                    InternalSubscriptionMetadata(choice: SubscriptionTimeIncrement.Monthly, localizedBundle: MembershipLocalizedBundle(title: "Monthly"), eligibleForTrial: true),
                    InternalSubscriptionMetadata(choice: SubscriptionTimeIncrement.Annual, localizedBundle: MembershipLocalizedBundle(title: "Annual"), eligibleForTrial: true),
                ]
            )
        }).task {
            try? await Task.sleep(nanoseconds: 1.nano())
            await MainActor.run {
                presented = true
            }
        }
    }
}
