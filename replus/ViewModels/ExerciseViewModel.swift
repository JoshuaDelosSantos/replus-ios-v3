//
//  ExerciseViewModel.swift
//  replus
//
//  Created by Joshua Delos Santos on 21/1/2025.
//


import CoreData


class ExerciseViewModel: ObservableObject {
    
    private let moc: NSManagedObjectContext
    
    @Published var session: Session?
    @Published var exercises: [Exercise] = []
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    
    
    private func saveContext() throws {
        if moc.hasChanges {
            print("SessionViewModel: Saving changes...")  // Log
            try moc.save()
            print("SessionViewModel: Changes saved")  // Log
        }
    }
}
