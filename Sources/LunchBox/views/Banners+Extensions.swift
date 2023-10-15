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
    BannerScrollView(content: {
        BannerView.ratingsBanner
        BannerView.thankYouSubBanner
        BannerView.premiumBanner()
    })
}

extension BannerView {
    
    static let ratingsBanner = BannerView(sublineText: "Keep us Motivated! Rate us", buttonText: "Rate us", buttonColor: Color.LBBannerDarkPurple, bannerColor: Color.LBBannerOffWhite, image: ParselableImage(parentName: "Banners", assetName: "icon-confetti-crown", sizeVariant: 1, systemImage: ""), onClick: {
        
    })
    
    static let thankYouSubBanner =  BannerView(sublineText: "Thank you for being a Premium member", buttonText: "", buttonColor: Color.clear, bannerColor: Color.LBIdealBlueSecondary, image: ParselableImage(parentName: "Banners", assetName: "icon-confetti-crown", systemImage: ""), onClick: {
    })
    
    
//    BannerView(sublineText: "Explore Cabinit and its Features", buttonText: "Learn More", buttonColor: Color("banner-dark-purple"), bannerColor: Color("banner-offwhite"), image: ParselableImage(parentName: "Banners", assetName: "icon-magnify-grass", systemImage: ""), webLink: "https://www.rezonating.app/features")
//
//    BannerView(sublineText: "Freshen up your Home Screen", buttonText: "Check Out Banners", buttonColor: Color("banner-offblack"), bannerColor: Color("banner-green"), image: ParselableImage(parentName: "Banners", assetName: "icon-phone-cold", systemImage: ""), onClick: {
//        aboutBannersPresented.toggle()
//    })
    
   
    
    static func premiumBanner(hasTrialAvailable: Bool = false) -> some View {
        BannerView(sublineText: hasTrialAvailable ? "Special Offer: Free Premium For new users!" : "Cabinit Premium: More Features, Less Limits", buttonText: hasTrialAvailable ? "Try for Free" : "Check it out", buttonColor: Color.LBIdealBluePrimary, bannerColor: Color.LBIdealBlueSecondary, image: ParselableImage(parentName: "Banners", assetName: "icon-confetti-crown", systemImage: ""), onClick: {
            PurchasesManager.shared.showMembershipModal()
        })
    }
}
