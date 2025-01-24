//
//  ExerciseViewModelTests.swift
//  replus
//
//  Created by Joshua Delos Santos on 21/1/2025.
//


import XCTest
import CoreData
@testable import replus


final class ExerciseViewModelTests: XCTestCase {
    
    var viewModel: ExerciseViewModel!
    var moc: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        let persistenceController = PersistenceController(inMemory: true)
        moc = persistenceController.container.viewContext // Correctly assign to the class-level property
        
        viewModel = ExerciseViewModel(moc: moc)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        moc = nil
    }
    
    func testAddExercise_ValidSession() {
        // Given
        let session = createTestSession(name: "Test Session")
        viewModel.session = session
        
        // When
        viewModel.addExercise(name: "Test Exercise")
        
        // Then
        XCTAssertEqual(viewModel.exercises.count, 1, "Exercises array should contain one exercise after adding.")
        XCTAssertEqual(viewModel.exercises.first?.name, "Test Exercise", "Exercise name should match the added exercise.")
    }
    
    func testUpdateExercise() {
        // Given
        let session = createTestSession(name: "Test Session")
        viewModel.session = session
        viewModel.addExercise(name: "Original Exercise")
        let exercise = viewModel.exercises.first!
        
        // When
        viewModel.updateExercise(exercise: exercise, name: "Updated Exercise")
        
        // Then
        XCTAssertEqual(viewModel.exercises.count, 1, "Exercises array should still contain one exercise after update.")
        XCTAssertEqual(viewModel.exercises.first?.name, "Updated Exercise", "Exercise name should be updated.")
    }
    
    
    /// Helper functions
    private func createTestSession(name: String) -> Session {
        let session = Session(context: moc)
        session.id = UUID()
        session.name = name
        session.modifiedAt = Date()
        
        do {
            try moc.save()
        } catch {
            XCTFail("Failed to save test session: \(error.localizedDescription)")
        }
        
        return session
    }
    
    private func createTestExercise(name: String, session: Session) {
        let exercise = Exercise(context: moc)
        exercise.id = UUID()
        exercise.name = name
        exercise.session = session
        exercise.modifiedAt = Date()
        
        do {
            try moc.save()
        } catch {
            XCTFail("Failed to save test exercise: \(error.localizedDescription)")
        }
    }
}
