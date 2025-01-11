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
    @Published var sessionToUpdate: Session? = nil
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        fetchSessions()
    }

// MARK: - Fetch Sessions.
    func fetchSessions() {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        
        // Logging
        let sessionNames = sessions.compactMap { $0.name }
        print("SessionViewModel: Session names: \(sessionNames.joined(separator: ", "))")  // Log
        
        do {
            // Fetch sessions from core data
            sessions = try moc.fetch(request)
            print("SessionViewModel: Fetched \(sessions.count) sessions")  // Log
            
        } catch {
            // Log Error
            print("SessionViewModel: Failed to fetch sessions: \(error.localizedDescription)")  // Log
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
            
            print("SessionViewModel: Added Session = \(newSession.name ?? "Unknown")")  // Log
            fetchSessions()
        } catch {
            print(error)
        }
    }

// MARK: - Updating a Session.
    func updateSession(newName: String) {
        guard let session = sessionToUpdate else {
            print("SessionViewModel: No session available to update.")  // Log
            return
        }
        
        do {
            session.name = newName
            session.modifiedAt = Date()
            
            try saveContext()
            
            print("SessionViewModel: Updated session to \(session.name ?? "Unknown")")  // Log
            fetchSessions()
        } catch {
            print("SessionViewModel: Failed to update session: \(error.localizedDescription)")  // Log
        }
    }
    
    
    func selectSession(id: UUID) {
        sessionToUpdate = getSessionById(id)
        if sessionToUpdate == nil {
            print("SessionViewModel: No session found with id \(id)")  // Log
        }
    }
    
    func getSelectedSessionName() -> String? {
        sessionToUpdate?.name
    }
    
// MARK: - Delete a Session.
    func deleteSession(_ session: Session) {
        print("SessionViewModel: Deleting session...")  // Log
        moc.delete(session)
        print("SessionViewModel: Session deleted")  // Log
        
        do {
            try saveContext()
            print("SessionViewModel: Deleted session with name \(session.name ?? "Unknown")")  // Log
            fetchSessions()
        } catch {
            print("SessionViewModel: Failed to delete session: \(error.localizedDescription)")  // Log
        }
    }
    

// MARK: - Helper functions.
    private func saveContext() throws {
        if moc.hasChanges {
            print("SessionViewModel: Saving changes...")  // Log
            try moc.save()
            print("SessionViewModel: Changes saved")  // Log
        }
    }
    
    private func getSessionById(_ id: UUID) -> Session? {
        print("SessionViewModel: Grabbing session by ID...")  // Log
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            return try moc.fetch(request).first
        } catch {
            print("SessionViewModel: Failed to fetch session by id: \(error.localizedDescription)")  // Log
            return nil
        }
    }
}
