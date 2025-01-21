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
    
    func fetchExercises() {
        guard let session = session else {
            print("ExerciseViewModel: No session available for fetching execises.")  // Log
            return
        }
        
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "session == %@", session)
        
        do {
            exercises = try moc.fetch(request)
            print("ExerciseViewModel: Fetched \(exercises.count) exercises for session \(session.name ?? "Unknown").")
        } catch {
            print("ExerciseViewModel: Failed to fetch exercises: \(error.localizedDescription)")
        }
    }
    
    private func saveContext() throws {
        if moc.hasChanges {
            print("SessionViewModel: Saving changes...")  // Log
            try moc.save()
            print("SessionViewModel: Changes saved")  // Log
        }
    }
}
