//
//  MembershipRow.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
protocol MembershipFeatureRow {
    var feature: String { get }
    var icon: String { get }
    var featureName: LocalizedStringKey  { get }
    var description: LocalizedStringKey { get }
    var color: Color { get set }
}

@available(iOS 16.0.0, *)
struct MembershipRow: View {
    let membershipRow: MembershipFeatureRow
    var forceDark: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(membershipRow.color.opacity(0.2))
                .squareFrame(length: 40)
                .overlay {
                    Image(systemName: membershipRow.icon)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(membershipRow.color)
                }
//                .springsIn(offset: 20, duration: 0.3)

            VStack {
                Text(membershipRow.featureName)
                    .font(.system(size: 18, weight: .heavy, design: .default))
                    .aligned()
                    .foregroundStyle(membershipRow.color)
                Text(membershipRow.description)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .aligned()
                    .foregroundStyle(forceDark ? .white : .screenTone)
            }
        }.padding(.top, 8)
    }
}

@available(iOS 16.0.0, *)
struct MembershipRedesignRow_Previews: PreviewProvider {
    struct TestMembershipRow : MembershipFeatureRow {
        var feature: String = "Test"
        var icon: String = "folder"
        var featureName: LocalizedStringKey = "Full Access"
        var description: LocalizedStringKey = "Get full access to the resources that you need"
        var color: Color = Color.blue
    }
    static var previews: some View {
        VStack{
            MembershipRow(membershipRow: TestMembershipRow())
        }
    }
}

