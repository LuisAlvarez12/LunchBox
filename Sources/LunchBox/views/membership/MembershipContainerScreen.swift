//
//  MembershipContainerScreen.swift
//  
//
//  Created by Luis Alvarez on 9/16/23.
//

import SwiftUI

@available(iOS 13.0, *)
public struct LocalizedKeyWithPosition {
    let id: Int
    let feature: LocalizedStringKey
}

@available(iOS 13.0, *)
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
}

@available(iOS 16.0, *)
public struct MembershipContainerScreen: View {
    
    let purchasesManager = PurchasesManager.shared
    
    let membershipMetaData: MembershipMetaData
    let membershipFeatures: [LocalizedKeyWithPosition]
    @State var subscriptionOptions: [SubscriptionMetadata] = []
    
    @State var selectedChoice: SubscriptionMetadata? = nil
    
    public init(membershipMetaData: MembershipMetaData) {
        let keys: [LocalizedKeyWithPosition] = membershipMetaData.features.enumerated().map { (index, element) in
            return LocalizedKeyWithPosition(id: index, feature: element)
        }
        
        self.membershipMetaData = membershipMetaData
        self.membershipFeatures = keys
    }
    
    init(membershipMetaData: MembershipMetaData, subscriptionOptions: [SubscriptionMetadata]) {
        let keys: [LocalizedKeyWithPosition] = membershipMetaData.features.enumerated().map { (index, element) in
            return LocalizedKeyWithPosition(id: index, feature: element)
        }
        
        self.membershipMetaData = membershipMetaData
        self.membershipFeatures = keys
        self.subscriptionOptions = subscriptionOptions
    }
    
    public var screen: some View {
        VStack {
            VStack {
                HStack{
                    Spacer()
                    Image(systemName: "laurel.leading")
                        .font(.system(size: 90))
                        .foregroundStyle(Color.LBUtilityBrightYellow.gradient)
                    membershipMetaData.primaryMembershipColor
                        .squareFrame(length: 100)
                    Image(systemName: "laurel.trailing")
                        .font(.system(size: 90))
                        .foregroundStyle(Color.LBUtilityBrightYellow.gradient)
                    Spacer()
                }
                
                Text("Unlock the Full \(membershipMetaData.appName) Experience")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .bold()
                    .lineLimit(3)
                    .horPadding()
                    .padding(.bottom, 4)
                
                VStack(alignment: .leading){
                    ForEach(membershipFeatures, id: \.id) { item in
                        Label(title: {
                            Text(item.feature)
                        }, icon: {
                            Image(systemName: "checkmark")
                                .renderingMode(.template)
                                .foregroundStyle(membershipMetaData.primaryMembershipColor.gradient)
                                .bold()
                        } )
                    }
                }
            }
            VStack(spacing: 0) {
                ForEach(subscriptionOptions, id: \.choice) { option in
                    Button(action: {
                        selectedChoice = option
                    }, label: {
                        MembershipOption(option: option, isSelected: selectedChoice?.choice == option.choice)
                    })
                }
                
                Spacer()
                
                if let _choice = selectedChoice as? SubscriptionOptionMetadata {
                    Text(_choice.getConfirmationString())
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                        .multilineTextAlignment(.center)
                        .padding(6)
                    
                    AsyncPrimaryButton(text: _choice.eligibleForTrial ? "Try FREE and Subscribe" : "Continue", color: membershipMetaData.primaryMembershipColor, action: {
                        
                        let result = await purchasesManager.purchase(selectedChoice: _choice)
                        
                        if result is SubscriptionSuccess {
                            membershipMetaData.onSubscribeSuccess()
                        } else {
                            membershipMetaData.onSubscribeFailure()
                        }
                        
                    })
                    
                    AsyncSecondaryButton(text: "Restore", action: {
                        let result = await purchasesManager.restore(acceptableEntitlements: membershipMetaData.acceptedEntitlements)
                        
                        if result is SubscriptionSuccess {
                            membershipMetaData.onSubscribeSuccess()
                        } else {
                            membershipMetaData.onSubscribeFailure()
                        }
                    }).padding(.top, 4)
                }
            }.full()
        }
    }
    
    public var body: some View {
        ViewThatFits{
            screen
            ScrollView {
                screen
            }
        }.task {
            if subscriptionOptions.isEmpty {
                //                subscriptionOptions = await purchasesManager.getOfferings()
            }
        }
    }
}

@available(iOS 16.0, *)
struct MembershipContainerScreen_PreviewProvider : PreviewProvider {
    static var previews: some View {
        MembershipContainerScreen(
            membershipMetaData: MembershipMetaData(
                appName: "Cabinit",
                appMembershipName: "Plus",
                acceptedEntitlements: [""],
                heroImageAsset: "",
                primaryMembershipColor: Color.LBIdealBluePrimary,
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
                InternalSubscriptionMetadata(choice: SubscriptionTimeIncrement.Annual, localizedBundle: MembershipLocalizedBundle(title: "Annual"), eligibleForTrial: true)
            ])
        //        .asSheetPreview()
    }
}

@available(iOS 16.0, *)
extension View {
    func asSheetPreview() -> some View {
        self.modifier(SheetPreviewModifier())
    }
}

@available(iOS 16.0, *)
struct SheetPreviewModifier: ViewModifier {
    @State var presented = false
    
    func body(content: Content) -> some View {
        VStack{
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
                    InternalSubscriptionMetadata(choice: SubscriptionTimeIncrement.Annual, localizedBundle: MembershipLocalizedBundle(title: "Annual"), eligibleForTrial: true)
                ])
        }).task {
            try? await Task.sleep(nanoseconds: 1.nano())
            await MainActor.run {
                presented = true
            }
        }
    }
}
