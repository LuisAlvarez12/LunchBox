//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 10/2/23.
//

import SwiftUI

public struct ParselableNetworkImage {
   public let url: URL
   public let systemImage: String
    
    public init(url: URL, systemImage: String) {
        self.url = url
        self.systemImage = systemImage
    }
    
    public init(urlString: String, systemImage: String) {
        self.url = URL(string: urlString)!
        self.systemImage = systemImage
    }
}

public struct ParselableImage {
    
    public var assetImage: String? = nil
    public var systemImage: String? = nil
    public var networkImage: ParselableNetworkImage? = nil
    
    public init(assetImage: String? = nil, systemImage: String? = nil, networkImage: ParselableNetworkImage? = nil) {
        self.assetImage = assetImage
        self.systemImage = systemImage
        self.networkImage = networkImage
    }
    
    @ViewBuilder
    public func createImage(frame: CGFloat, color: Color = Color.LBIdealBluePrimary) -> some View {
        if let _networkImage = networkImage {
            AsyncImage(url: _networkImage.url) { image in
                    image
                    .resizable()
                    .scaledToFit()
                    .squareFrame(length: frame)
                  } placeholder: {
                      Image(systemName: _networkImage.systemImage)
                          .resizable()
                          .scaledToFit()
                          .squareFrame(length: frame)
                          .foregroundStyle(color)
                  }
        } else if let _assetImage = assetImage {
            Image(_assetImage)
                .resizable()
                .squareFrame(length: frame)
                .scaledToFit()
        } else if let _systemImage = systemImage {
            if #available(iOS 17.0, *) {
                Image(systemName: _systemImage)
                    .resizable()
                    .scaledToFit()
                    .squareFrame(length: frame)
                    .symbolEffect(.bounce, value: true)
                    .foregroundStyle(color)
                    
            } else {
                Image(systemName: _systemImage)
                    .resizable()
                    .scaledToFit()
                    .squareFrame(length: frame)
                    .foregroundStyle(color)
            }
        } else {
            Spacer()
        }
    }
}



#Preview {
    VStack {
        ParselableImage(systemImage: "folder").createImage(frame: 80)
        ParselableImage(systemImage: "globe").createImage(frame: 80, color: Color.red)
        ParselableImage(systemImage: "globe").createImage(frame: 80, color: Color.red)
        ParselableImage(networkImage: ParselableNetworkImage(urlString: "https://swiftanytime-content.s3.ap-south-1.amazonaws.com/SwiftUI-Beginner/Async-Image/TestImage.jpeg", systemImage: "star")).createImage(frame: 80, color: Color.red)
    }
}
