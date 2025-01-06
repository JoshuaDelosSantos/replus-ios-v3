//
//  Persistence.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//


import CoreData
import Foundation


class PersistenceController: ObservableObject {
    let container = NSPersistentContainer(name: "Replus")
    
    init () {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
