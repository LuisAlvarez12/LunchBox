//
//  PremiumView.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct PremiumView: View {
    public var size: CGFloat = 16
    public var color: Color = .yellow

    @State var anim: Int = 0

    public init(size: CGFloat, color: Color) {
        self.size = size
        self.color = color
    }

    private func updateAnim() {
        withAnimation(.easeIn(duration: 1.0)) {
            if (anim + 1) == 3 {
                anim = 0
            } else {
                anim += 1
            }
        }
    }

    public var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "crown.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(color)
                .squareFrame(length: size)
                .onAppear {
                    updateAnim()
                }
                .onChange(of: anim, perform: { _ in
                    Task {
                        try? await Task.sleep(nanoseconds: 4.nano())
                        await MainActor.run {
                            updateAnim()
                        }
                    }
                })
                .overlay(alignment: .top, content: {
                    SparkleShape()
                        .foregroundStyle(color.opacity(0.7))
                        .squareFrame(length: max(size * 0.2, 8))
                        .offset(x: 4)
                        .opacity(anim == 0 ? 1.0 : 0.0)
                })
                .background(alignment: .top, content: {
                    HStack {
                        SparkleShape()
                            .foregroundStyle(color.opacity(0.7))
                            .squareFrame(length: max(size * 0.3, 8))
                            .offset(x: 2, y: 2)
                            .opacity(anim == 1 ? 1.0 : 0.0)
                        Spacer()
                        SparkleShape()
                            .foregroundStyle(color.opacity(0.7))
                            .squareFrame(length: max(size * 0.2, 8))
                            .offset(x: 2, y: 4)
                            .opacity(anim == 2 ? 1.0 : 0.0)
                    }
                })
        }
    }
}

@available(iOS 16.0.0, *)
struct PremiumView_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            PremiumView(size: 100, color: .red)
            PremiumView(size: 50, color: .red)
            PremiumView(size: 24, color: .red)
            PremiumView(size: 16, color: .red)
        }
    }
}

struct SparkleShape: View {
    var body: some View {
        Image(systemName: "sparkle")
            .resizable()
            .scaledToFit()
    }
}
