//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 10/1/23.
//

import SwiftUI

public extension View {
    func infoSheet(isPresented: Binding<Bool>, title: LocalizedStringKey, desc: LocalizedStringKey? = nil, image: ParselableImage? = nil, buttonText: LocalizedStringKey = "OK") -> some View {
        modifier(LBSheetModifier(isPresented: isPresented, title: title, desc: desc, image: image, buttonText: buttonText))
    }
}

public extension View {
    @ViewBuilder
    func materialSheet() -> some View {
        if #available(iOS 16.4.1, *) {
            self
                .padding()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(Material.thick)
                .presentationCornerRadius(30)
        } else {
            padding()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

public struct LBSheetModifier: ViewModifier {
    @Binding var isPresented: Bool

    let title: LocalizedStringKey
    let desc: LocalizedStringKey?
    let image: ParselableImage?
    let buttonText: LocalizedStringKey

    public init(isPresented: Binding<Bool>, title: LocalizedStringKey, desc: LocalizedStringKey? = nil, image: ParselableImage? = nil, buttonText: LocalizedStringKey) {
        _isPresented = isPresented
        self.title = title
        self.desc = desc
        self.image = image
        self.buttonText = buttonText
    }

    public var sheet: some View {
        VStack {
            Spacer().frame(height: 42)
            Text(title)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .bold()

            if let desc {
                Text(desc)
                    .multilineTextAlignment(.center)
                    .padding(.top, 1)
                    .padding(.horizontal, 20)
            }

            Spacer()

            if let image {
                image.createImage(widthFrame: 160, frame: 80)
            }

            Spacer()
            Spacer()

            #if os(visionOS)

                Button(buttonText, action: {
                    isPresented = false
                }).padding(.bottom)
            #else
                SecondaryButton(text: buttonText, action: {
                    isPresented = false
                }).padding(.bottom)
            #endif
        }

        .background(Color.LBMonoSchemeTone.visionableClear())
        .presentationDetents([.medium])
    }

    public func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented, content: {
            #if os(visionOS)
                sheet

            #else
                if #available(iOS 16.4, *) {
                    sheet.presentationCornerRadius(80)
                } else {
                    sheet
                }
            #endif

        })
    }
}

#Preview {
    let networkImage = ParselableNetworkImage(urlString: ParselableNetworkImage.buildLink(parentName: "Cabinit", assetName: "icon-color-palette", sizeVariant: 1), systemImage: "globe")

    return Color.blue
        .infoSheet(isPresented: .constant(true), title: "Setup Folder Name", desc: GenericFaker.words(23).localized(), image: ParselableImage(networkImage: networkImage), buttonText: "Continue")
}
