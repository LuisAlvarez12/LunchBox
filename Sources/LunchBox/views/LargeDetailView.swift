//
//  LargeDetailView.swift
//  UnderCovers
//
//  Created by Luis Alvarez on 6/17/24.
//

import SwiftUI

struct LargeDetailView: View {
    let systemImage: String
    let title: LocalizedStringKey
    var subtitle: String = ""
    var imageColor: Color = .blue

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: systemImage)
                .font(.subheadline)
                .padding(8)
                .background(Circle().foregroundStyle(imageColor))
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

#Preview {
    let stack = VStack {
        LargeDetailView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
        HStack {
            Button(action: {}, label: {
                LargeDetailView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
            }).buttonStyle(.plain)
            Button(action: {}, label: {
                LargeDetailView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
            })
        }
        HStack {
            LargeDetailView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
            LargeDetailView(systemImage: "folder", title: "All Files", subtitle: "32", imageColor: Color.green)
        }
    }

    ScrollView {
        stack
            .frame(width: 250)
        stack
            .frame(width: 300)
        stack
    }
}
