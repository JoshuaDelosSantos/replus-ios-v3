//
//  Persistence.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//


import CoreData
import Foundation


class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "replus")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") // Use in-memory store for previews
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
    }
}
