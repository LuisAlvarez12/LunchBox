//
//  CircularProgressView.swift
//  UnderCovers
//
//  Created by Luis Alvarez on 12/7/24.
//

import SwiftUI

public struct CircularProgressView: View {
    public let progress: Double
    public var color: Color = .blue
    public let width: CGFloat = 6
    
    public init(progress: Double, color: Color) {
        self.progress = progress
        self.color = color
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.4),
                    lineWidth: width
                )
            Circle()
                // 2
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: width,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}
