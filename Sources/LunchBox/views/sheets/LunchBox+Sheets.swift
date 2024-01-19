//
//  SwiftUIView.swift
//  
//
//  Created by Luis Alvarez on 1/18/24.
//

import SwiftUI

public struct SheetSettings {
    public var isDraggable = false
    public var isMaterial = false
    public var showsCloseButton = false
}

public extension View {
    public func lunchboxsheet<Content>(sheetSettings: SheetSettings? = nil, isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        #if os(visionOS)
            return self.sheet(isPresented: isPresented, content: {
                content()
                    .overlay(alignment: .topLeading, content: {
                        Button(action: {
                            isPresented.wrappedValue = false
                        }, label: {
                                Label("Close", systemImage: "xmark")
                                .labelStyle(.iconOnly)
                        }).padding()
                    })
            })
        #else
        return self.sheet(isPresented: isPresented, content: {
            content()
                .overlay(alignment: .topLeading, content: {
                    Button(action: {
                        isPresented.wrappedValue = false
                    }, label: {
                            Label("Close", systemImage: "xmark")
                            .labelStyle(.iconOnly)
                    }).padding()
                })
        })
        #endif
     
    }
}

#Preview {
    @State var sheetPresented = false
    
    return VStack{
        Button("open", action: {
            sheetPresented = true
        })
    }.lunchboxsheet(isPresented: $sheetPresented, content: {
        Color.red
    })
}
