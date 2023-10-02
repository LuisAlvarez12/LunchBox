//
//  SwiftUIView.swift
//
//
//  Created by Luis Alvarez on 10/1/23.
//

import SwiftUI

public extension View {
    func infoSheet(isPresented: Binding<Bool>,title: LocalizedStringKey, desc: LocalizedStringKey? = nil, image: ParselableImage? = nil, buttonText: LocalizedStringKey = "OK") -> some View {
        self
            .modifier(LBSheetModifier(isPresented: isPresented, title: title, desc: desc, image: image, buttonText: buttonText))
        
    }
}

public struct LBSheetModifier: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isPresented: Bool
    
    let title: LocalizedStringKey
    let desc: LocalizedStringKey?
    let image: ParselableImage?
    let buttonText: LocalizedStringKey
    
    public init(isPresented: Binding<Bool>, title: LocalizedStringKey, desc: LocalizedStringKey? = nil, image: ParselableImage? = nil, buttonText: LocalizedStringKey) {
        self._isPresented = isPresented
        self.title = title
        self.desc = desc
        self.image = image
        self.buttonText = buttonText
    }
    
    public var sheet: some View {
        VStack{
            Spacer()
            Text(title)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top)
                .bold()
            
            if let desc {
                Text(desc)
                    .multilineTextAlignment(.center)
                    .padding(.top, 1)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            if let image {
                image.createImage(frame: 80)
            }
            
            Spacer()
            Spacer()
            
            SecondaryButton(text: buttonText, action: {
                dismiss()
            })
        }
        
        .background(Color.LBMonoSchemeTone)
        .presentationDetents([.medium])
    }
    
    public func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented, content: {
            if #available(iOS 16.4, *) {
                sheet.presentationCornerRadius(80)
            } else {
                sheet
            }
        })
    }
}

public struct ParselableImage {
    
    public var assetImage: String? = nil
    public var systemImage: String? = nil
    
    public init(assetImage: String? = nil, systemImage: String? = nil) {
        self.assetImage = assetImage
        self.systemImage = systemImage
    }
    
    @ViewBuilder
    public func createImage(frame: CGFloat, color: Color = Color.LBIdealBluePrimary) -> some View {
        if let _assetImage = assetImage {
            Image(_assetImage)
                .resizable()
                .squareFrame(length: frame)
                .scaledToFit()
        } else if let _systemImage = systemImage {
            if #available(iOS 17.0, *) {
                Image(systemName: _systemImage)
                    .resizable()
                    .squareFrame(length: frame)
                    .scaledToFit()
                    .symbolEffect(.bounce, value: true)
                    .foregroundStyle(color)
                    
            } else {
                Image(systemName: _systemImage)
                    .resizable()
                    .squareFrame(length: frame)
                    .scaledToFit()
                    .foregroundStyle(color)
            }
        } else {
            Spacer()
        }
    }
}



//#Preview {
//    
//    @State var f = false
//    
//    Color.blue
//        .infoSheet(isPresented: $f, title: "Setup Folder Name", desc: GenericFaker.words(23).localized(), image: ParselableImage(systemImage: "globe"), buttonText: "Continue")
//}
