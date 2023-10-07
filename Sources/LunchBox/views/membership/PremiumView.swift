//
//  PremiumView.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0.0, *)
public struct PremiumView: View {
    var showCrown = false

    @State var anim: Int = 0

    public init(showCrown: Bool = false) {
        self.showCrown = showCrown
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
            Group {
                if showCrown {
                    Image(systemName: "crown.fill")
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
                                .fill(Color.yellow)
                                .squareFrame(length: 8)
                                .offset(x: 4)
                                .opacity(anim == 0 ? 1.0 : 0.0)
                        })
                        .background(alignment: .top, content: {
                            HStack {
                                SparkleShape()
                                    .fill(Color.yellow)
                                    .squareFrame(length: 8)
                                    .offset(x: 2, y: 2)
                                    .opacity(anim == 1 ? 1.0 : 0.0)
                                Spacer()
                                SparkleShape()
                                    .fill(Color.yellow)
                                    .squareFrame(length: 8)
                                    .offset(x: 2, y: 4)
                                    .opacity(anim == 2 ? 1.0 : 0.0)
                            }
                        })
                } else {
                    Image(systemName: "laurel.leading")
                    Text("Premium")
                    Image(systemName: "laurel.trailing")
                }
            }
        }
    }
}

public struct PremiumViewButton: View {
    @ObservedObject var purchasesMagager = PurchasesManager.shared

    var showCrown = false

    public init(showCrown: Bool = false) {
        self.showCrown = showCrown
    }

    @ViewBuilder
    public var body: some View {
        Button(action: {
            if !purchasesMagager.isSubscribed() {
                purchasesMagager.showMembershipModal()
            }
        }, label: {
            if purchasesMagager.isSubscribed() {
                EmptyView()
            } else {
                PremiumView(showCrown: showCrown)
            }
        })
    }
}

@available(iOS 16.0.0, *)
struct PremiumView_PreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
//            PremiumView().foregroundStyle(.blue)
            PremiumView(showCrown: true)
                .foregroundStyle(.red.gradient)
        }
    }
}

struct SparkleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = 1.0
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX - radius, y: rect.midY - radius))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - radius, y: rect.midY + radius))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + radius, y: rect.midY + radius))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX + radius, y: rect.midY - radius))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}
