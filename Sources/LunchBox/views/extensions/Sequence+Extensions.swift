//
//  Sequence+Extensions.swift
//
//
//  Created by Luis Alvarez on 9/13/23.
//

import SwiftUI

/// Extension to extract an array of only the unique values
public extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

@available(iOS 16.0, *)
public func asyncCallback<T>(_ context: String = "callback", start: @escaping (@escaping (T?, Error?) -> Void) -> Void) async throws -> T {
    try await withCheckedThrowingContinuation { continuation in
        start { result, error in
            guard let result = result else {
                guard let error = error else {
                    continuation.resume(throwing: KNAsyncError.UnderlyingApiInvalidBehavior("\(context) returned neither result nor error"))
                    return
                }
                continuation.resume(throwing: error)
                return
            }
            continuation.resume(returning: result)
        }
    }
}

public extension Collection {
    var indexedDictionary: [Int: Element] {
        return Dictionary(uniqueKeysWithValues: enumerated().map { ($0, $1) })
    }
}

@available(iOS 16.0, *)
public class AsyncCallbackAdaptor<T> {
    private let task: Task<T, Error>

    public init(context: String = "callback", start: @escaping (@escaping (T?, Error?) -> Void) -> Void) {
        task = Task { try await asyncCallback(context, start: start) }
    }

    public func await() async throws -> T {
        try await task.value
    }
}

public enum KNAsyncError: Error {
    case UnderlyingApiInvalidBehavior(String)
}

// Need a concrete type for the task group
private struct IndexedItem<T> {
    let index: Int
    let item: T
}

public extension Sequence {
    func collect() -> [Element] {
        reduce(into: []) { $0.append($1) }
    }
}

@available(iOS 16.0.0, *)
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

@available(iOS 16.0, *)
public extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: []) { $0.append($1) }
    }
}
