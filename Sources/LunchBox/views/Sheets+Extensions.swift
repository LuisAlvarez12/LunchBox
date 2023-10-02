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
                isPresented = false
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

//#Preview {
//    
//    @State var f = false
//    
//    Color.blue
//        .infoSheet(isPresented: $f, title: "Setup Folder Name", desc: GenericFaker.words(23).localized(), image: ParselableImage(systemImage: "globe"), buttonText: "Continue")
//}
