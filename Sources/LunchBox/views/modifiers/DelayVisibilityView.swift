//
//  DelayVisibilityView.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 13.0, *)
struct DelayVisibilityView<Content>: View where Content: View {
    
    let delay: CGFloat
    @ViewBuilder var content: () -> Content
    
    @State var showView = false

    var body: some View {
        VStack {
            if showView {
                content()
            }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { // 1 sec delay
                withAnimation {
                    showView = true
                }
               }
        }
    }
}

@available(iOS 13.0.0, *)
struct DelayVisibilityView_Previews: PreviewProvider {
    static var previews: some View {
        DelayVisibilityView(delay: 2.0) {
            Color.red
        }
    }
}
