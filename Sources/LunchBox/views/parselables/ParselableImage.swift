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
        url = URL(string: urlString)!
        self.systemImage = systemImage
    }

    public init(parentName: String, assetName: String, sizeVariant: Int = 1, systemImage: String) {
        url = URL(string: Self.buildLink(parentName: parentName, assetName: assetName, sizeVariant: sizeVariant))!
        self.systemImage = systemImage
    }

    public static func buildLink(parentName: String, assetName: String, sizeVariant: Int = 1) -> String {
        "https://raw.githubusercontent.com/LuisAlvarez12/AppAssets/main/\(parentName)/\(assetName)/\(sizeVariant)x.png"
    }
}

public struct ParselableImage {
    public var assetImage: String?
    public var systemImage: ParselableSystemImage?
    public var networkImage: ParselableNetworkImage?
    
    public var backgroundColor: Color = .black

    public init(assetImage: String? = nil, systemImage: ParselableSystemImage? = nil, networkImage: ParselableNetworkImage? = nil, backgroundColor: Color = .black) {
        self.assetImage = assetImage
        self.systemImage = systemImage
        self.networkImage = networkImage
        self.backgroundColor = backgroundColor
    }

    public init(parentName: String, assetName: String, sizeVariant: Int = 1, systemImage: String) {
        let url = URL(string: ParselableNetworkImage.buildLink(parentName: parentName, assetName: assetName, sizeVariant: sizeVariant))!
        networkImage = ParselableNetworkImage(url: url, systemImage: systemImage)
    }
    
    @ViewBuilder
    public func createImage(width: CGFloat, height: CGFloat, contentMode: ContentMode = .fit, color: Color = LunchboxThemeManager.shared.currentColor) -> some View {
        if let _networkImage = networkImage {
            AsyncImage(url: _networkImage.url,
                       transaction: Transaction(animation: .snappy))
            { phase in
                switch phase {
                case .empty:
                    EmptyView()
                        .squareFrame(length: height)
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                case let .failure(error):
                    Image(systemName: _networkImage.systemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                        .foregroundStyle(color)
                @unknown default:
                    EmptyView()
                        .frame(width: width, height: height)
                }
            }
            .frame(width: width, height: height)
        } else if let _assetImage = assetImage {
            Image(_assetImage)
                .resizable()
                .frame(width: width, height: height)
                .scaledToFit()
        } else if let _systemImage = systemImage {
            if #available(iOS 17.0, *) {
                Image(systemName: _systemImage.systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .symbolEffect(.bounce, value: true)
                    .foregroundStyle(_systemImage.color ?? color)

            } else {
                Image(systemName: _systemImage.systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .foregroundStyle(_systemImage.color ?? color)
            }
        } else {
            Spacer()
        }
    }

    @ViewBuilder
    public func createImage(widthFrame: CGFloat? = nil, frame: CGFloat, color: Color = LunchboxThemeManager.shared.currentColor) -> some View {
        if let _networkImage = networkImage {
            AsyncImage(url: _networkImage.url,
                       transaction: Transaction(animation: .snappy))
            { phase in
                switch phase {
                case .empty:
                    EmptyView()
                        .squareFrame(length: frame)
                case let .success(image):
                    if let widthFrame {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: widthFrame)
                    } else {
                        image
                            .resizable()
                            .scaledToFit()
                            .squareFrame(length: frame)
                    }
                case let .failure(error):
                    Image(systemName: _networkImage.systemImage)
                        .resizable()
                        .scaledToFit()
                        .squareFrame(length: frame)
                        .foregroundStyle(color)
                @unknown default:
                    EmptyView()
                        .squareFrame(length: frame)
                }
            }
            .frame(width: widthFrame != nil ? widthFrame! : frame, height: widthFrame != nil ? .infinity : frame)
        } else if let _assetImage = assetImage {
            Image(_assetImage)
                .resizable()
                .squareFrame(length: frame)
                .scaledToFit()
        } else if let _systemImage = systemImage {
            if #available(iOS 17.0, *) {
                Image(systemName: _systemImage.systemImage)
                    .resizable()
                    .scaledToFit()
                    .squareFrame(length: frame)
                    .symbolEffect(.bounce, value: true)
                    .foregroundStyle(_systemImage.color ?? color)

            } else {
                Image(systemName: _systemImage.systemImage)
                    .resizable()
                    .scaledToFit()
                    .squareFrame(length: frame)
                    .foregroundStyle(_systemImage.color ?? color)
            }
        } else {
            Spacer()
        }
    }
}

public struct ParselableSystemImage {
    public let systemImage: String
    public var color: Color?

    public init(_ systemImage: String, color: Color? = nil) {
        self.systemImage = systemImage
        self.color = color
    }
}

#Preview {
    VStack {
        ParselableImage(systemImage: ParselableSystemImage("folder")).createImage(frame: 80)
        ParselableImage(systemImage: ParselableSystemImage("folder")).createImage(frame: 80, color: Color.red)
        ParselableImage(systemImage: ParselableSystemImage("folder")).createImage(frame: 80, color: Color.red)
        ParselableImage(networkImage: ParselableNetworkImage(urlString: "https://raw.githubusercontent.com/LuisAlvarez12/AppAssets/main/General/icon-folder/3x.png", systemImage: "star")).createImage(frame: 80, color: Color.red)
    }
}
