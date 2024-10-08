//
//  CircularProgressView.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

@available(iOS 16.0, *)
public struct CircularProgressView: View {
    let progress: Double

    public init(progress: Double) {
        self.progress = progress
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(
                    AppThemeManager.shared.currentTheme.primary.opacity(0.5),
                    lineWidth: 24
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AppThemeManager.shared.currentTheme.primary,
                    style: StrokeStyle(
                        lineWidth: 24,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

@available(iOS 16.0, *)
struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            CircularProgressView(progress: 0.25)
                .squareFrame(length: 100)
            CircularProgressView(progress: 0.5)
                .squareFrame(length: 200)
        }
    }
}
