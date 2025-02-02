//
//  PreviewUtils.swift
//  UnderCovers
//
//  Created by Luis Alvarez on 12/7/24.
//

import LunchBox
import SwiftUI

extension View {
    func previewDelay(_ time: Double = 0.5, action: @escaping () -> Void) -> some View {
        return task {
            await delay(time)
            withAnimation(.bouncy) {
                action()
            }
        }
    }
}

struct SheetPreview<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack {
            Color.clear
        }.full().sheet(isPresented: .constant(true)) {
            content()
                .withLanguage(.English)
        }
    }
}

struct FullSheetPreview<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack {
            Color.clear
        }.full().fullScreenCover(isPresented: .constant(true)) {
            content()
                .withLanguage(.English)
        }
    }
}

func delay(_ seconds: Double) async {
    try? await Task.sleep(nanoseconds: seconds.nano())
}

// Localizations
#Preview {
    Color.red
}
