//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 6/19/24.
//

import SwiftUI

public struct HeaderNavigationView: View {
    public let systemImage: String
    public let title: LocalizedStringKey
    public var subtitle: String = ""
    public var imageColor: Color = .white
    public var imageBackground: Color = .blue

    public init(systemImage: String, title: LocalizedStringKey, subtitle: String = "", imageColor: Color = .white, imageBackground: Color = .blue) {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.imageColor = imageColor
        self.imageBackground = imageBackground
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: systemImage)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(imageColor)
                .padding(8)
                .background(Circle().foregroundStyle(imageBackground))
            HStack {
                Text(title)
                    .font(.subheadline)
                    .lineLimit(1)
                    .bold()
                Spacer()
                Text(subtitle)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Material.thin)
        }
        .contentShape(.hoverEffect, .rect(cornerRadius: 12))
        .hoverEffect()
    }
}

public struct HeaderParselableView: View {
    public let image: ParselableImage
    public let title: LocalizedStringKey
    public var subtitle: String = ""
    public var imageColor: Color = .white
    public var imageBackground: Color = .blue

    public init(image: ParselableImage, title: LocalizedStringKey, subtitle: String = "", imageColor: Color = .white, imageBackground: Color = .blue) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.imageColor = imageColor
        self.imageBackground = imageBackground
    }

    public var body: some View {
        VStack(alignment: .leading) {
            image.createImage(frame: 32)
            HStack {
                Text(title)
                    .autoFit(size: 16)
                    .lineLimit(1)
                    .bold()
                Spacer()
                Text(subtitle)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Material.thin)
        }
        .contentShape(.hoverEffect, .rect(cornerRadius: 12))
        .hoverEffect()
    }
}

#Preview {
    NavigationSplitView(sidebar: {
        HeaderNavigationView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
        HStack {
            Button(action: {}, label: {
                HeaderParselableView(image: ParselableImage(parentName: "General", assetName: "icon-folder-square", systemImage: "folder.fill"), title: "Files", subtitle: "", imageColor: Color.green)

            }).buttonStyle(.plain)
            Button(action: {}, label: {
                HeaderParselableView(image: ParselableImage(parentName: "General", assetName: "icon-star-2", systemImage: "star.fill"), title: "Favorites", subtitle: "", imageColor: Color.green)

            }).buttonStyle(.plain)
            Button(action: {}, label: {
                HeaderParselableView(image: ParselableImage(parentName: "Cabinit", assetName: "icon-3d-globe", systemImage: "folder.fill"), title: "Browser", subtitle: "", imageColor: Color.green)

            }).buttonStyle(.plain)
        }

        HStack {
            HeaderNavigationView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
            HeaderNavigationView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.white, imageBackground: Color.orange)
        }

    }, detail: {
        Color.red
    })
}

#Preview {
    NavigationSplitView(sidebar: {
        HeaderNavigationView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
        HStack {
            Button(action: {}, label: {
                HeaderNavigationView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
            }).buttonStyle(.plain)
            Button(action: {}, label: {
                HeaderNavigationView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
            }).buttonStyle(.plain)
        }
        HStack {
            HeaderNavigationView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
            HeaderNavigationView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.white, imageBackground: Color.orange)
        }

    }, detail: {
        Color.red
    })
}
