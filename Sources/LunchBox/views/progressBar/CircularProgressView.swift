//
//  CircularProgressView.swift
//  UnderCovers
//
//  Created by Luis Alvarez on 12/7/24.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    var color: Color = .blue
    let width: CGFloat = 6

    var body: some View {
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
