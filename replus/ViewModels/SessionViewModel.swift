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
        fetchSessions()
    }
    
    func fetchSessions() {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        
        do {
            // Fetch sessions from core data
            sessions = try moc.fetch(request)
            print("SessionViewModel: Fetched \(sessions.count) sessions")
            
        } catch {
            // Log Error
            print("SessionViewModel: Failed to fetch sessions: \(error.localizedDescription)")
        }
    }
    
    func addSession(name: String) {
        let newSession = Session(context: moc)
        
        do {
            newSession.id = UUID()
            newSession.name = name
            newSession.modifiedAt = Date()
            
            try saveContext()
            
            // Log
            print("SessionViewModel: Added Session = \(newSession.name ?? "Unknown")")
            fetchSessions()
        } catch {
            print(error)
        }
    }
    
    func updateSession(session: Session, newName: String) {
        do {
            session.name = newName
            session.modifiedAt = Date()
            
            try saveContext()
            
            print("SessionViewModel: Updated Session")
            fetchSessions()
        } catch {
            print(error)
        }
    }
    
    private func saveContext() throws {
        if moc.hasChanges {
            try moc.save()
        }
    }
}
