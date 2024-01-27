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
    var bgColor: Color = .black

    @State var image: UIImage? = nil

    public init(url: URL, onDoubleTap: (() -> Void)? = nil, image: UIImage? = nil, bgColor: Color = Color.black) {
        self.url = url
        self.onDoubleTap = onDoubleTap
        self.image = image
        self.bgColor = bgColor
    }

    public var body: some View {
        Color.clear
            .full()
            .overlay {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .full()
                        .background(bgColor)
                        .pinchToZoom(onDoubleTap: {})
                }
            }.onAppear {
                self.image = url.toUIImage().resized(withPercentage: 1.0)
            }.onDisappear {
                self.image = nil
            }
    }
}
