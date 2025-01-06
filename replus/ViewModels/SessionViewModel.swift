//
//  SessionViewModel.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//


import CoreData


class SessionViewModel: ObservableObject {
    
    private let moc: NSManagedObjectContext
    
    @Published var sessions: [Session] = []
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func fetchSessions() {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        
        do {
            // Fetch sessions from core data
            sessions = try moc.fetch(request)
            print("Fetched \(sessions.count) sessions")
            
        } catch {
            // Log Error
            print("SessionViewModel: Failed to fetch sessions: \(error.localizedDescription)")
        }
    }
}
