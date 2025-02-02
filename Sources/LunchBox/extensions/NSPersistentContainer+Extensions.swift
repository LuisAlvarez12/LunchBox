//
//  NSPersistentContainer+Extensions.swift
//
//
//  Created by Luis Alvarez on 9/14/23.
//

import CoreData
import SwiftUI

@available(iOS 16.0, *)
public extension NSPersistentContainer {
    /// Saves changes in the container's view context with a completion handler
    /// - Parameter completion: Optional closure called after the save operation completes
    public func save(completion: @escaping (Error?) -> Void = { _ in }) {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    /// Asynchronously saves changes in the container's view context
    /// - Returns: An AsyncResponse indicating success or failure of the save operation
    public func save() async -> AsyncResponse {
        let context = viewContext
        do {
            try await context.perform {
                try context.save()
            }
            return AsyncSuccess()
        } catch {
            return AsyncFailure()
        }
    }

    /// Asynchronously deletes an object from the persistent store
    /// - Parameter object: The NSManagedObject to delete
    /// - Returns: An AsyncResponse indicating success or failure of the delete operation
    public func delete(_ object: NSManagedObject) async -> AsyncResponse {
        let context = viewContext

        context.delete(object)
        do {
            try await context.perform {
                try context.save()
            }
            return AsyncSuccess()
        } catch {
            return AsyncFailure()
        }
    }

    /// Deletes an object from the persistent store with a completion handler
    /// - Parameters:
    ///   - object: The NSManagedObject to delete
    ///   - completion: Optional closure called after the delete operation completes
    public func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> Void = { _ in }) {
        let context = viewContext
        context.delete(object)
        save(completion: completion)
    }
}
