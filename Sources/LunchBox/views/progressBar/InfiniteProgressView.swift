//
//  InfiniteProgressView.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

// the height of the bar
private let height: CGFloat = 4
// how much does the blue part cover the gray part (40%)
private let coverPercentage: CGFloat = 0.4
private let minOffset: CGFloat = -2
private let maxOffset = 1 / coverPercentage * abs(minOffset)

@available(iOS 16.0, *)
public struct InfiniteProgressBar: View {
    @State private var offset = minOffset

    public init() {}

    public var body: some View {
        Rectangle()
            .foregroundColor(Color.systemSecondary) // change the color as you see fit
            .frame(height: height)
            .overlay(
                GeometryReader { geo in
                    overlayRect(in: geo.frame(in: .local))
                })
    }

    private func overlayRect(in rect: CGRect) -> some View {
        let width = rect.width * coverPercentage
        return Rectangle()
            .foregroundStyle(Color.LBIdealBluePrimary)
            .frame(width: width)
            .offset(x: width * offset)
            .onAppear {
                withAnimation(Animation.linear(duration: 1.6).repeatForever(autoreverses: false)) {
                    self.offset = maxOffset
                }
            }
    }
}

@available(iOS 16.0, *)
struct InfiniteProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteProgressBar()
    }
}
