//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 10/15/23.
//

import SwiftUI

struct BannerScrollView<Content>: View where Content: View {

    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ScrollView(.horizontal, content: {
            HStack {
                Spacer().frame(width: 16)
                content()
                Spacer()
            }
        }).scrollIndicators(.hidden)
    }
}

#Preview {
//    Color.red
    BannerScrollView(content: {
        BannerView.checkOutCabinitBanner
        BannerView.changeAppIconBanner {
            
        }
        BannerView.ratingsBanner {
            
        }
        BannerView.requestFeatureBanner(appName: "Uncover")
        BannerView.thankYouSubBanner
        BannerView.premiumBanner(appName: "Uncover")
    })
}

public extension BannerView {
    
    public static func ratingsBanner(requestReview: @escaping () -> Void) -> some View {
        BannerView(sublineText: "Help us grow\nConsider rating us", buttonText: "Rate this app", sublineTextColor: .LBBannerOffWhite, buttonColor: Color.LBBannerYellow,buttonTextColor: Color.LBBannerOffBlack, bannerColor: Color.LBBannerOffBlack, image: ParselableImage(parentName: "General", assetName: "icon-ratings-stars", sizeVariant: 1, systemImage: ""), onClick: {
            requestReview()
        })
    }
    
    public static func changeAppIconBanner(changeIcons: @escaping () -> Void) -> some View {
        BannerView(sublineText: "Customize your\nApp Icon", buttonText: "Try Now", sublineTextColor: .LBBannerOffBlack, buttonColor: Color.LBBannerYellow,buttonTextColor: Color.LBBannerOffBlack, bannerColor: Color.LBBannerLimeGreen, image: ParselableImage(parentName: "Banners", assetName: "icon-app-icons", sizeVariant: 1, systemImage: ""), onClick: {
            changeIcons()
        })
    }
    
    public static let thankYouSubBanner =  BannerView(sublineText: "Thank you for being a Premium member", buttonText: "", buttonColor: Color.clear, bannerColor: Color.LBIdealBlueSecondary, image: ParselableImage(parentName: "Banners", assetName: "icon-confetti-crown", systemImage: ""), onClick: {
       
    })
    
    public static let checkOutCabinitBanner =  BannerView(sublineText: "Lock your Files with our\nnew app, Cabinit", buttonText: "Check it out", buttonColor: Color.LBBannerOffBlack, bannerColor: Color.LBBannerOffWhite, image: ParselableImage(parentName: "Cabinit", assetName: "icon-folder-main-icon", systemImage: ""), onClick: {
        if let url = URL(string: "https://itunes.apple.com/app/id1631243885") {
            UIApplication.shared.open(url)
        }
    })
    
    public static func requestFeatureBanner(appName: String) -> some View {
        BannerView(sublineText: "Improve \(appName)\nRequest a Feature", buttonText: "Mail us!", buttonColor: Color.LBBannerRed, buttonTextColor: Color.white, bannerColor: Color.LBBannerPink, image: ParselableImage(parentName: "General", assetName: "icon-house-mail", systemImage: ""), onClick: {
            UIApplication.shared.sendEmail(subject: "Feature Request: \(appName)", emailBody: "What is a feature you would like to see in \(appName)?\n\n\n")
    })
}
    
    
//    BannerView(sublineText: "Explore Cabinit and its Features", buttonText: "Learn More", buttonColor: Color("banner-dark-purple"), bannerColor: Color("banner-offwhite"), image: ParselableImage(parentName: "Banners", assetName: "icon-magnify-grass", systemImage: ""), webLink: "https://www.rezonating.app/features")
//
//    BannerView(sublineText: "Freshen up your Home Screen", buttonText: "Check Out Banners", buttonColor: Color("banner-offblack"), bannerColor: Color("banner-green"), image: ParselableImage(parentName: "Banners", assetName: "icon-phone-cold", systemImage: ""), onClick: {
//        aboutBannersPresented.toggle()
//    })
    
    public static func premiumBanner(appName: String, hasTrialAvailable: Bool = false) -> some View {
        BannerView(sublineText: hasTrialAvailable ? "Special Offer: Free Premium For new users!" : "\(appName) Premium: More Features, Less Limits", buttonText: hasTrialAvailable ? "Try for Free" : "Check it out", buttonColor: Color.LBIdealBluePrimary, bannerColor: Color.LBIdealBlueSecondary, image: ParselableImage(parentName: "Banners", assetName: "icon-confetti-crown", systemImage: ""), onClick: {
            PurchasesManager.shared.showMembershipModal()
        })
    }
}
