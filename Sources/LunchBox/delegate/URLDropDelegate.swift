//
//  URLDropDelegate.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI

/// A delegate that handles drag and drop operations for URLs in SwiftUI.
/// This delegate specifically handles files and folders being dropped onto a view.
///
/// Usage:
/// ```swift
/// .onDrop(of: [.data, .folder], delegate: URLDropDelegate { items in
///     // Handle dropped items here
/// })
/// ```
@available(iOS 16, *)
public struct URLDropDelegate: DropDelegate {
    /// The UTType identifier for file data
    static let CONFORMING_TYPE_DATA = "public.data"
    /// The UTType identifier for folders
    static let CONFORMING_TYPE_FOLDER = "public.folder"

    /// Closure that gets called when items are successfully dropped
    /// - Parameter items: An array of NSItemProvider objects representing the dropped items
    let onDroppedItems: ([NSItemProvider]) -> Void

    /// Creates a new URLDropDelegate instance
    /// - Parameter onDroppedItems: A closure that will be called when items are dropped.
    ///   The closure receives an array of NSItemProvider objects representing the dropped items.
    public init(onDroppedItems: @escaping ([NSItemProvider]) -> Void) {
        self.onDroppedItems = onDroppedItems
    }

    /// Handles the actual drop operation when items are dropped onto the view
    /// - Parameter info: Information about the drop operation
    /// - Returns: Boolean indicating whether the drop was handled successfully
    public func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: [URLDropDelegate.CONFORMING_TYPE_DATA]) || info.hasItemsConforming(to: [URLDropDelegate.CONFORMING_TYPE_FOLDER]) else {
            return false
        }

        let items = info.itemProviders(for: [URLDropDelegate.CONFORMING_TYPE_DATA, URLDropDelegate.CONFORMING_TYPE_FOLDER])

        onDroppedItems(items)
        return true
    }
}
