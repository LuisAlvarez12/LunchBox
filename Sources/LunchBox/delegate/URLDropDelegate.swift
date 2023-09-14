//
//  URLDropDelegate.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

@available(iOS 16, *)
public struct URLDropDelegate: DropDelegate {
    static let CONFORMING_TYPE_DATA = "public.data"
    static let CONFORMING_TYPE_FOLDER = "public.folder"

    let onDroppedItems: ([NSItemProvider]) -> Void

    public func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: [URLDropDelegate.CONFORMING_TYPE_DATA]) || info.hasItemsConforming(to: [URLDropDelegate.CONFORMING_TYPE_FOLDER]) else {
            return false
        }

        let items = info.itemProviders(for: [URLDropDelegate.CONFORMING_TYPE_DATA, URLDropDelegate.CONFORMING_TYPE_FOLDER])

        onDroppedItems(items)
        return true
    }
}
