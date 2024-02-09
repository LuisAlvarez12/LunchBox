//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 10/6/23.
//

import SafariServices
import SwiftUI

public struct ParselableLabelData {
    public let text: LocalizedStringKey
    public let image: ParselableImage
    public let size: CGFloat
    public var color: Color = .LBIdealBluePrimary
}

public struct BannerView: View {
    public let parselableLabelData: ParselableLabelData?
    public let sublineText: LocalizedStringKey
    public var sublineTextColor: Color = .black
    public let buttonText: LocalizedStringKey
    public let buttonColor: Color
    public let bannerColor: Color
    public var buttonTextColor: Color = .white
    public let image: ParselableImage
    public var webLink: String? = nil
    public var onClick: (() -> Void)? = nil

    private let width: CGFloat = 320
    private let height: CGFloat = 110

    public init(parselableLabelData: ParselableLabelData? = nil, sublineText: LocalizedStringKey, buttonText: LocalizedStringKey, sublineTextColor: Color = .black, buttonColor: Color, buttonTextColor: Color = Color.white, bannerColor: Color, image: ParselableImage, webLink: String? = nil, onClick: (() -> Void)? = nil) {
        self.parselableLabelData = parselableLabelData
        self.sublineText = sublineText
        self.buttonText = buttonText
        self.buttonColor = buttonColor
        self.sublineTextColor = sublineTextColor
        self.bannerColor = bannerColor
        self.buttonTextColor = buttonTextColor
        self.image = image
        self.webLink = webLink
        self.onClick = onClick
    }

    var bg: some View {
        RoundedRectangle(cornerRadius: 8).foregroundStyle(bannerColor)
            .full()
    }

    @ViewBuilder
    var content: some View {
        #if os(visionOS)
        HStack {
            image.createImage(widthFrame: 60, frame: 60, color: buttonColor)
                .background(Circle().foregroundStyle(bannerColor.gradient))
            
            VStack(alignment: .trailing, spacing: 0) {
                Text(sublineText)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                
                Text(buttonText)
                    .font(.footnote)
                    .foregroundStyle(buttonTextColor)
                    .lineLimit(1)
                    .bold()
                    .horPadding()
                    .vertPadding(4)
                    .background(Capsule().foregroundStyle(buttonColor))
                    .padding(.top, 4)
            }.padding(8)

        }.frame(maxWidth: 270)
            .horPadding()
            .lunchboxGlassEffect()
            .clipped()
        #else
        if #available(iOS 17.0, *) {
            HStack {
                VStack(spacing: 0) {
                    //                if let parselableLabelData {
                    //                    ParselableLabel(parselableLabelData)
                    //                    // ParselableLabel.ParselableLabelData(text: "Premium", image: ParselableImage(networkImage: .folder), size: 20)
                    //                }

                    image.createImage(widthFrame: 60, frame: 60, color: buttonColor)

                    Text(sublineText)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(2, reservesSpace: true)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(sublineTextColor)
                    Text(buttonText)
                        .font(.footnote)
                        .foregroundStyle(buttonTextColor)
                        .bold()
                        .horPadding()
                        .vertPadding(4)
                        .background(Capsule().foregroundStyle(buttonColor))
                        .padding(.top, 4)
                }.padding(8)

            }.frame(width: 200)
                .background(bg)
                .clipped()
        } else {
            HStack {
                VStack(alignment: .leading) {
                    Spacer()

                    Text(sublineText)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(2, reservesSpace: true)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(sublineTextColor)
                        .aligned()
                    Text(buttonText)
                        .font(.footnote)
                        .foregroundStyle(buttonTextColor)
                        .bold()
                        .horPadding(8)
                        .vertPadding(8)
                        .background(Capsule().foregroundStyle(buttonColor))
                }.padding([.leading, .vertical], 16)

                image.createImage(widthFrame: 100, frame: 100, color: buttonColor)

            }.frame(width: width, height: height)
                .background(bg)
                .clipped()
        }
        #endif
    }

    @ViewBuilder
    public var body: some View {
        if let onClick {
            Button(action: {
                onClick()
            }, label: {
                content
            }).buttonStyle(.plain)
        } else if let webLink {
            WebButton(url: webLink) {
                content
            }
        }
    }
}

private struct TestBanners: View {
    var body: some View {
        BannerView.ratingsBanner {}

        BannerView(sublineText: GenericFaker.words(20).localized(), buttonText: GenericFaker.words(3).localized(), buttonColor: LunchboxThemeManager.shared.currentColor, bannerColor: Color.LBIdealBlueSecondary, image: ParselableImage(parentName: "Premium", assetName: "icon-crown", systemImage: ""), onClick: {})

        BannerView(sublineText: GenericFaker.words(20).localized(), buttonText: GenericFaker.words(3).localized(), buttonColor: Color.red, bannerColor: Color.white, image: ParselableImage(parentName: "Premium", assetName: "icon-crown", systemImage: ""), onClick: {})

        BannerView(sublineText: GenericFaker.words(20).localized(), buttonText: GenericFaker.words(3).localized(), buttonColor: Color.yellow, bannerColor: Color.green, image: ParselableImage(parentName: "Premium", assetName: "icon-crown", systemImage: ""), onClick: {})
    }
}

#Preview {
    ScrollView(.horizontal, content: {
        HStack {
            Spacer().frame(width: 16)
            TestBanners()
            Spacer()
        }
    }).scrollIndicators(.hidden)
}

@available(iOS 17.0, *)
#Preview {
    VStack {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
//                    let isSubscribed = purchasesManager.isSubscribed()
                BannerView.premiumBanner(appName: "Uncover", hasTrialAvailable: true)
                BannerView.ratingsBanner {
//                        requestReview()
                }
                BannerView.checkOutCabinitBanner
                BannerView.requestFeatureBanner(appName: "Uncover")
                BannerView.thankYouSubBanner
                BannerView.checkOutCabinitBanner
                BannerView.requestFeatureBanner(appName: "Uncover")
                BannerView.thankYouSubBanner
            }
            .padding()
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
    }
}

public struct ParselableLabel: View {
    public let data: ParselableLabelData

    public init(_ data: ParselableLabelData) {
        self.data = data
    }

    public var body: some View {
        Label(
            title: { Text(data.text).foregroundStyle(Color.black) },
            icon: { data.image.createImage(frame: data.size, color: data.color) }
        )
    }
}

struct WebButton<Content>: View where Content: View {
    var url: String
    @ViewBuilder var content: () -> Content

    @State var browserPresented: Bool = false

    var body: some View {
        Button(action: {
            browserPresented.toggle()
        }, label: {
            content()
        })
        .sheet(isPresented: $browserPresented, content: {
            MiniWebBrowserScreen(url: URL(string: url)!)
                .edgesIgnoringSafeArea(.bottom)
        })
    }
}

struct MiniWebBrowserScreen: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController

    let url: URL

    func makeUIViewController(context _: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_: SFSafariViewController, context _: UIViewControllerRepresentableContext<MiniWebBrowserScreen>) {}
}
