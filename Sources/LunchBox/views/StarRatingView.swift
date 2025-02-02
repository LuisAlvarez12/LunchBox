////
////  StarRatingView.swift
////  UnderCovers
////
////  Created by Luis Alvarez on 12/23/24.
////
//
//import SwiftUI
//
//public struct StarRatingView: View {
//    public let document: some Hashable
//    @Binding var rating: Double
//    @State var isStatic: Bool = false
//    let onRatingSet: () -> Void
//
//    private let maxRating = 5
//    private let starSize: CGFloat = 30
//
//    var size: CGFloat {
//        if isStatic {
//            18
//        } else {
//            starSize
//        }
//    }
//
//    public var body: some View {
//        GeometryReader { geometry in
//            HStack(spacing: 10) {
//                let fillColor = isStatic ? currentAppTheme.text.primary : .yellow
//
//                ForEach(1 ... maxRating, id: \.self) { index in
//                    ZStack {
//                        Image(systemName: "star")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: size, height: size)
//                            .foregroundColor(.secondary)
//
//                        if rating >= Double(index) {
//                            Image(systemName: "star.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: size, height: size)
//                                .foregroundColor(fillColor)
//                        } else if rating >= Double(index) - 0.5 {
//                            Image(systemName: "star.leadinghalf.filled")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: size, height: size)
//                                .foregroundColor(fillColor)
//                        }
//                    }
//                    .onTapGesture {
//                        if isStatic {
//                            withAnimation {
//                                isStatic = false
//                            }
//                        } else {
//                            let tappedRating = Double(index)
//                            rating = (
//                                rating == tappedRating
//                            ) ? tappedRating - 0.5 : tappedRating
//                        }
//                    }
//                }
//            }
//            .gesture(
//                DragGesture(minimumDistance: 0)
//                    .onChanged { value in
//                        guard !isStatic else {
//                            return
//                        }
//                        let starWidth = geometry.size.width / CGFloat(maxRating)
//                        let preciseRating = Double(value.location.x / starWidth)
//                        rating = min(
//                            max(
//                                0,
//                                preciseRating
//                                    .rounded(.down) + (
//                                        preciseRating
//                                            .truncatingRemainder(
//                                                dividingBy: 1
//                                            ) >= 0.5 ? 0.5 : 0
//                                    )
//                            ),
//                            Double(maxRating)
//                        )
//                    }
//            )
//        }
//        .task(id: rating) {
//            try? await Task.sleep(nanoseconds: 1.nano()) // debounce
//            await FileReviewManager.shared.addRating(document: document, rating: rating)
//            onRatingSet()
//        }
//        .frame(width: size * CGFloat(maxRating) + CGFloat((maxRating - 1) * 10), height: size)
//    }
//}
//
//struct StaticStarRatingView: View {
//    var rating: Double
//
//    private let maxRating = 5
//    private let starSize: CGFloat = 30
//
//    var size: CGFloat {
//        18
//    }
//
//    var body: some View {
//        GeometryReader { _ in
//            HStack(spacing: 10) {
//                let fillColor = currentAppTheme.text.primary
//
//                ForEach(1 ... maxRating, id: \.self) { index in
//                    ZStack {
//                        Image(systemName: "star")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: size, height: size)
//                            .foregroundColor(.secondary)
//
//                        if rating >= Double(index) {
//                            Image(systemName: "star.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: size, height: size)
//                                .foregroundColor(fillColor)
//                        } else if rating >= Double(index) - 0.5 {
//                            Image(systemName: "star.leadinghalf.filled")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: size, height: size)
//                                .foregroundColor(fillColor)
//                        }
//                    }
//                }
//            }
//        }
//        .frame(width: size * CGFloat(maxRating) + CGFloat((maxRating - 1) * 10), height: size)
//    }
//}
//
//#Preview {
//    @Previewable @State var rating = 3.0
//    return StarRatingView(document: .sampleDocument, rating: $rating, isStatic: true) {}
//}
//
//struct FakeStarRatingView: View {
//    @State var rating: Double = 0.0
//
//    private let maxRating = 5
//    private let starSize: CGFloat = 30
//
//    var size: CGFloat {
//        starSize
//    }
//
//    @State var isActive = false
//
//    var body: some View {
//        GeometryReader { _ in
//            HStack(spacing: 10) {
//                let fillColor = Color.yellow
//
//                ForEach(1 ... maxRating, id: \.self) { index in
//                    ZStack {
//                        Image(systemName: "star")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: size, height: size)
//                            .foregroundColor(Color.secondary)
//
//                        if rating >= Double(index) {
//                            Image(systemName: "star.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: size, height: size)
//                                .foregroundColor(fillColor)
//                        } else if rating >= Double(index) - 0.5 {
//                            Image(systemName: "star.leadinghalf.filled")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: size, height: size)
//                                .foregroundColor(fillColor)
//                        }
//                    }
//                }
//            }
//        }
//        .task {
//            isActive = true
//            await goTo5Stars()
//        }
//        .onDisappear {
//            isActive = false
//        }
//        .frame(width: size * CGFloat(maxRating) + CGFloat((maxRating - 1) * 10), height: size)
//    }
//
//    func goTo5Stars() async {
//        try? await Task.sleep(nanoseconds: 1.nano()) // debounce
//        withAnimation(.spring) {
//            rating = 1.0
//        }
//
//        try? await Task.sleep(nanoseconds: 0.5.nano())
//        withAnimation(.spring) {
//            rating = 2.0
//        }
//        try? await Task.sleep(nanoseconds: 0.5.nano())
//        withAnimation(.spring) {
//            rating = 3.0
//        }
//        try? await Task.sleep(nanoseconds: 0.5.nano())
//        withAnimation(.spring) {
//            rating = 4.0
//        }
//        try? await Task.sleep(nanoseconds: 0.5.nano())
//        withAnimation(.spring) {
//            rating = 5.0
//        }
//
//        try? await Task.sleep(nanoseconds: 4.nano())
//        if isActive {
//            await goTo5Stars()
//        }
//    }
//}
//
//#Preview {
//    FakeStarRatingView()
//}
