//
//  SessionViewModel.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//


import CoreData


class SessionViewModel: ObservableObject {
    
    private let moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func fetchSessions() {
        
    }
}
