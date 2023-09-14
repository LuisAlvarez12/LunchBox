//
//  OptimizedURLImage.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct MemorySafeURLImage: View {
    let url: URL
    var onDoubleTap: (() -> Void)? = nil

    @State var image: UIImage? = nil

    public var body: some View {
        Color.clear
            .full()
            .overlay {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .full()
                        .background(Color.black)
                        .pinchToZoom(onDoubleTap: {})
                }
            }.onAppear {
                self.image = url.toUIImage().resized(withPercentage: 1.0)
            }.onDisappear {
                self.image = nil
            }
    }
}
