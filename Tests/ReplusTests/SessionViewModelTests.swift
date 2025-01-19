//
//  SessionViewModelTests.swift
//  replus
//
//  Created by Joshua Delos Santos on 19/1/2025.
//


import XCTest
import CoreData
@testable import replus


final class SessionViewModelTests: XCTestCase {
    
    /// Properties
    var viewModel: SessionViewModel!
    var moc: NSManagedObjectContext!
    
    /// Setup
    override func setUpWithError() throws {
        let persistenceController = PersistenceController(inMemory: true)
        moc = persistenceController.container.viewContext // Correctly assign to the class-level property
        
        // Initialize ViewModel with the MOC
        viewModel = SessionViewModel(moc: moc)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        moc = nil
    }
    
    func testFetchSessions() {
        // Given
        let session = Session(context: moc)
        session.id = UUID()
        session.name = "Test Session"
        session.modifiedAt = Date()
        
        try? moc.save() // Save the session to the in-memory context
        
        // When
        viewModel.fetchSessions()
        
        // Then
        XCTAssertEqual(viewModel.sessions.count, 1, "ViewModel should fetch one session.")
        XCTAssertEqual(viewModel.sessions.first?.name, "Test Session", "Session name should match the test data.")
    }
    
    func testAddSession() {
        // When
        viewModel.addSession(name: "New Session")
        
        // Then
        XCTAssertEqual(viewModel.sessions.count, 1, "ViewModel should add one session.")
        XCTAssertEqual(viewModel.sessions.first?.name, "New Session", "Added sessions name should match.")
    }
    
    func testUpdateSession() {
        // Given
        let session = Session(context: moc)
        session.id = UUID()
        session.name = "Old Session"
        session.modifiedAt = Date()
        try? moc.save()
        viewModel.fetchSessions()
        
        // When
        viewModel.selectSession(id: session.id!)
        viewModel.updateSession(newName: "Updated Session")
        
        // Then
        XCTAssertEqual(viewModel.sessions.first?.name, "Updated Session", "Session name should be updated.")
    }
    
    func testDeleteSession() {
        // Given: Add a session
        let session = Session(context: moc)
        session.id = UUID()
        session.name = "To Be Deleted"
        session.modifiedAt = Date()
        try? moc.save()
        viewModel.fetchSessions()
        
        // When: Deleting the session
        viewModel.selectSession(id: session.id!)
        viewModel.deleteSession()
        
        // Then: Validate the session is deleted
        XCTAssertEqual(viewModel.sessions.count, 0, "ViewModel should delete the session.")
    }
}
