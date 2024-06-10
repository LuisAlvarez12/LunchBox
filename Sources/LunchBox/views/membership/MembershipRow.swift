//
//  MembershipRow.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
public protocol MembershipFeatureRow {
    var feature: String { get }
    var icon: String { get }
    var featureName: LocalizedStringKey { get }
    var description: LocalizedStringKey { get }
    var color: Color { get set }
}

@available(iOS 16.0.0, *)
public struct MembershipRow: View {
    let membershipRow: MembershipFeatureRow
    var forceDark: Bool = false

    public init(membershipRow: MembershipFeatureRow, forceDark: Bool) {
        self.membershipRow = membershipRow
        self.forceDark = forceDark
    }

    public var body: some View {
        #if os(visionOS)
            VisionDetailsCard(image: ParselableImage(systemImage: ParselableSystemImage(membershipRow.icon, color: Color.white)), title: membershipRow.featureName, subTitle: " ", bodyText: membershipRow.description, bgColor: membershipRow.color, showSubtitle: false)

        #else
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(membershipRow.color.opacity(0.2))
                    .squareFrame(length: 40)
                    .overlay {
                        Image(systemName: membershipRow.icon)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(membershipRow.color)
                    }
                    .springsIn(offset: 20, duration: 0.3)

                VStack {
                    Text(membershipRow.featureName)
                        .font(.system(size: 18, weight: .heavy, design: .default))
                        .aligned()
                        .foregroundStyle(membershipRow.color)
                    Text(membershipRow.description)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .aligned()
                        .foregroundStyle(forceDark ? .white : Color.LBMonoScreenOffTone)
                }
            }.padding(.top, 8)
        #endif
    }
}

@available(iOS 16.0.0, *)
struct MembershipRedesignRow_Previews: PreviewProvider {
    struct TestMembershipRow: MembershipFeatureRow {
        var feature: String = "Test"
        var icon: String = "folder"
        var featureName: LocalizedStringKey = "Full Access tot new asd"
        var description: LocalizedStringKey = "Get full access to the resources that you need"
        var color: Color = .blue
    }

    static var previews: some View {
        VStack {
            MembershipRow(membershipRow: TestMembershipRow(), forceDark: false)
        }
    }
}

public struct VisionDetailsCard: View {
    let image: ParselableImage
    let title: LocalizedStringKey
    var subTitle: LocalizedStringKey = ""
    let bodyText: LocalizedStringKey
    let bgColor: Color
    var showSubtitle = true

    public init(image: ParselableImage, title: LocalizedStringKey, subTitle: LocalizedStringKey = "", bodyText: LocalizedStringKey, bgColor: Color, showSubtitle: Bool = true) {
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.bodyText = bodyText
        self.bgColor = bgColor
        self.showSubtitle = showSubtitle
    }

    public var body: some View {
        VStack {
            image
                .createImage(frame: 60)
                .fullWidth()
                .vertPadding(8)
                .background(bgColor.gradient.opacity(0.8))

            Text(title)
                .autoFit(size: 32, weight: .bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .horPadding()

            if showSubtitle {
                Text(subTitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .bold()
                    .textCase(.uppercase)
                    .horPadding()
            }

            Text(bodyText)
                .font(.subheadline)
                .autoFit(size: 20)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
                .horPadding()
            Spacer()
        }.frame(maxWidth: 250, maxHeight: 300).lunchboxGlassEffect()
    }
}

public struct VisionNavigationCard: View {
    let route: any Hashable
    let image: ParselableImage
    let title: LocalizedStringKey
    var subTitle: LocalizedStringKey = ""
    let bodyText: LocalizedStringKey
    var isChecked = false
    var imageSize: CGFloat = 110

    public init(route: any Hashable, image: ParselableImage, title: LocalizedStringKey, subTitle: LocalizedStringKey = " ", bodyText: LocalizedStringKey, isChecked: Bool = false, imageSize: CGFloat = 110) {
        self.route = route
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.bodyText = bodyText
        self.isChecked = isChecked
        self.imageSize = imageSize
    }

    public var body: some View {
        NavigationLink(value: route, label: {
            VStack {
                if isChecked {
                    CheckMarkView(size: imageSize)
                } else {
                    image.createImage(frame: imageSize)
                }

                Text(title)
                    .font(.largeTitle)

                Text(subTitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .bold()
                    .textCase(.uppercase)

                Text(bodyText)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3, reservesSpace: true)
                    .padding(.top, 8)

            }.frame(maxWidth: 200).padding().lunchboxGlassEffect()
        }).buttonStyle(.plain)
    }
}

import SwiftUI

public struct CheckMarkView: View {
    var size: CGFloat = 40
    var color: Color = .green

    public init(size: CGFloat = 40, color: Color = Color.green) {
        self.size = size
        self.color = color
    }

    public var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .symbolRenderingMode(.palette)
            .foregroundStyle(Color.white, color.gradient)
            .scaledToFit()
            .frame(idealWidth: size, maxWidth: size, idealHeight: size, maxHeight: size)
            .padding()
            .allowsHitTesting(false)
    }
}

struct CheckMarkView_Previews: PreviewProvider {
    static var previews: some View {
        CheckMarkView()
    }
}

public extension View {
    func lunchboxGlassEffect() -> some View {
        #if os(visionOS)
            glassBackgroundEffect()
        #else
            self
        #endif
    }
}
