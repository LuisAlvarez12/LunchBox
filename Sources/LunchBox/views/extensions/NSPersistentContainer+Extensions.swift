//
//  NSPersistentContainer+Extensions.swift
//  
//
//  Created by Luis Alvarez on 9/14/23.
//

import SwiftUI
import CoreData

@available(iOS 15.0, *)
extension NSPersistentContainer {
    
    func save(completion: @escaping (Error?) -> Void = { _ in }) {
        let context = self.viewContext
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
        let context = self.viewContext
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
        let context = self.viewContext

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
        let context = self.viewContext
        context.delete(object)
        save(completion: completion)
    }
    
}
