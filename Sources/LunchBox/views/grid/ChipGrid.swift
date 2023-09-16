//
//  ChipGrid.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16.0, *)
public protocol ChipGridItem {
    var chipID: UUID { get }
    var chipName: String { get }
}

@available(iOS 16.0, *)
public struct ChipGrid: View {
    let chipGridItems: [ChipGridItem]

    public init(chipGridItems: [ChipGridItem], onSelect: @escaping (ChipGridItem) -> Void, selected: ChipGridItem? = nil, arr: [[ChipGridItem]] = [[ChipGridItem]]()) {
        self.chipGridItems = chipGridItems
        self.onSelect = onSelect
        self.selected = selected
        self.arr = arr
    }

    func getArrays() {
        var chunk0 = [ChipGridItem]()
        var chunk1 = [ChipGridItem]()
        var chunk2 = [ChipGridItem]()

        var pointer = 0

        chipGridItems.forEach { i in
            if pointer == 0 {
                chunk0.append(i)
            }
            if pointer == 1 {
                chunk1.append(i)
            }
            if pointer == 2 {
                chunk2.append(i)
            }

            // increment
            if pointer == 2 {
                pointer = 0
            } else {
                pointer += 1
            }
        }

        arr = [chunk0, chunk1, chunk2]
    }

    let onSelect: (ChipGridItem) -> Void
    var selected: ChipGridItem? = nil

    @State var arr = [[ChipGridItem]]()

    public var body: some View {
        ScrollView(.horizontal) {
            if arr.isNotEmpty {
                VStack {
                    ForEach(0 ..< arr.count) { index in
                        HStack {
                            ForEach(arr[index], id: \.chipID) { item in
                                ChipView(systemImage: "folder", title: item.chipName, isSelected: item.chipID == selected?.chipID)
                                    .onTapGesture {
                                        onSelect(item)
                                    }
                            }
                            Spacer()
                        }
                    }
                }.vertPadding(4)
            }
        }.onAppear {
            getArrays()
        }
    }
}

@available(iOS 16.0, *)
public struct ChipView: View {
    let systemImage: String
    let title: String
    var isSelected = false

    public var body: some View {
        HStack(spacing: 4) {
//               Image(systemName: systemImage)
//                .font(.system(size: 18)).lineLimit(1)
            Text(title).lineLimit(1)
                .bold(isSelected)
        }
        .horPadding(12)
        .vertPadding(8)
        .foregroundColor(isSelected ? Color.white : Color.LBMonoScreenOffTone)
        .background {
            let bgColor = isSelected ? Color.LBIdealBluePrimary : Color.LBMonoScreenOffTone

            Capsule().fill(bgColor)
        }
    }
}

@available(iOS 16.0, *)
struct ShareSheetScreen_Previews: PreviewProvider {
    private struct ChipExample: ChipGridItem {
        var chipID: UUID = .init()
        var chipName: String
    }

    static var previews: some View {
//        StatefulPreviewWrapper(nil){
//            ChipGrid(chipGridItems: [
//                ChipExample(chipName: "References"),
//                ChipExample(chipName: "Dinner Recipes"),
//                ChipExample(chipName: "SwiftUI"),
//                ChipExample(chipName: "Twitter Threads"),
//                ChipExample(chipName: "Vacation Ideas"),
//                ChipExample(chipName: "Car pics"),
//                ChipExample(chipName: "Music"),
//                ChipExample(chipName: "Upcoming Concerts"),
//                ChipExample(chipName: "Reddit threads"),
//                ChipExample(chipName: "Manga"),
//                ChipExample(chipName: "Comics"),
//                ChipExample(chipName: "Video Game stuff"),
//                ChipExample(chipName: "Blender 3D")
//            ], selected: $0)
//        }

        VStack {
            ChipView(systemImage: "folder", title: "References", isSelected: true)
            ChipView(systemImage: "folder", title: "Dinner Ideas", isSelected: false)
        }
    }
}

@available(iOS 16.0, *)
public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
