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

public struct MembershipMetaData {
    let appName: String
    // Premium, plus, etc
    let appMembershipName: String
}

@available(iOS 16.0, *)
public struct MembershipContainerScreen: View {
    
    let membershipMetaData: MembershipMetaData
    let membershipFeatures: [LocalizedKeyWithPosition]
    
    public init(membershipMetaData: MembershipMetaData, features: [LocalizedStringKey]) {
        let keys: [LocalizedKeyWithPosition] = features.enumerated().map { (index, element) in
            return LocalizedKeyWithPosition(id: index, feature: element)
        }
        
        self.membershipMetaData = membershipMetaData
        self.membershipFeatures = keys
    }
    
    public var body: some View {
        VStack {
            VStack {
                Text("Unlock the Full \(membershipMetaData.appName) Experience")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding(.top)
                
//                HStack(spacing: 0){
//                    Text("\(membershipMetaData.appName)")
//                        .font(.subheadline)
//                        
//                    Text("\(membershipMetaData.appMembershipName)")
//                        .font(.subheadline)
//                        .bold()
//                        .foregroundStyle(.white)
//                        .horPadding(8)
//                        .background(Capsule().fill(Color.blue.gradient))
//                        .horPadding(2)
//                }
                
                VStack(alignment: .leading){
                    ForEach(membershipFeatures, id: \.id) { item in
                        Label(title: {
                                  Text(item.feature)
                              }, icon: {
                                  Image(systemName: "checkmark")
                                      .renderingMode(.template)
                                      .foregroundStyle(Color.blue.gradient)
                                      .bold()
                              } )
                    }
                }.padding(8)
            }
            
            VStack {
                Color.orange
            }.full()
        }.background{
            VStack {
                Color.red.squareFrame(length: 50)
                Spacer()
            }.full()
        }
    }
}

@available(iOS 16.0, *)
struct MembershipContainerScreen_PreviewProvider : PreviewProvider {
    static var previews: some View {
        MembershipContainerScreen(
            membershipMetaData: MembershipMetaData(
                appName: "Cabinit",
                appMembershipName: "Plus"),
            features: [
        "Multiple Cabins",
        "Audio and Video Playback",
        "Read Supported Book Files",
        "No File Limits",
        "Face ID",
        "Emergency Wipe",
        ])
    }
}
