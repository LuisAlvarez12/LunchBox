//
//  Sequence+Extensions.swift
//  Cabinit (iOS)
//
//  Created by Luis Alvarez on 12/30/21.
//

import Foundation

/// Extension to extract an array of only the unique values
public extension Sequence where Iterator.Element: Hashable {
    public func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

public extension Collection {
    var indexedDictionary: [Int: Element] {
        return Dictionary(uniqueKeysWithValues: enumerated().map { ($0, $1) })
    }
}

// Need a concrete type for the task group
private struct IndexedItem<T> {
    let index: Int
    let item: T
}

public extension Sequence {
    func mapAsync<T>(task: @escaping (Element) async throws -> T) async rethrows -> [T] {
        try await withThrowingTaskGroup(of: IndexedItem<T>.self, returning: [T].self) { group in
            for (index, item) in enumerated() {
                group.addTask {
                    try IndexedItem(index: index, item: await task(item))
                }
            }
            return try await group.collect().sorted { $0.index < $1.index }.map(\.item)
        }
    }

    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}

public extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: []) { $0.append($1) }
    }
}
