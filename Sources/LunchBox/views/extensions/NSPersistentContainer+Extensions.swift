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
    func save(completion: @escaping (Error?) -> Void = { _ in }) {
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

    func save() async -> AsyncResponse {
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

    func delete(_ object: NSManagedObject) async -> AsyncResponse {
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

    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> Void = { _ in }) {
        let context = viewContext
        context.delete(object)
        save(completion: completion)
    }
}
