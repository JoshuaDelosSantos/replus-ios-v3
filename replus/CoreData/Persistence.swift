//
//  Persistence.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//


import CoreData
import Foundation


class PersistenceController: ObservableObject{
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ReplusModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") // Use in-memory store for previews
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                print("Persistence: Unresolved error \(error), \(error.localizedDescription)")
            }
        }
    }
}
