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

// MARK: - Fetch Sessions.
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

// MARK: - Adding a Session.
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

// MARK: - Updating a Session.
    func updateSession(id: UUID, newName: String) {
        guard let session = getSessionById(id) else {
            print("SessionViewModel: No session found with id \(id)")
            return
        }
        
        do {
            session.name = newName
            session.modifiedAt = Date()
            
            try saveContext()
            
            print("SessionViewModel: Updated session \(session.name ?? "Unknown")")
            fetchSessions()
        } catch {
            print("SessionViewModel: Failed to update session: \(error.localizedDescription)")
        }
    }
    
    private func getSessionById(_ id: UUID) -> Session? {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            return try moc.fetch(request).first
        } catch {
            print("SessionViewModel: Failed to fetch session by id: \(error.localizedDescription)")
            return nil
        }
    }

// MARK: - Saving Context.
    private func saveContext() throws {
        if moc.hasChanges {
            try moc.save()
        }
    }
}
