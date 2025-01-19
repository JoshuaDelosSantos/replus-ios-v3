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
        let moc = persistenceController.container.viewContext
        
        // Initialise MOC and ViewModel
        viewModel = SessionViewModel(moc: moc)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        moc = nil
    }
    
}
