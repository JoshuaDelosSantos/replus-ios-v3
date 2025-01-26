//
//  ExerciseListView.swift
//  replus
//
//  Created by Joshua Delos Santos on 20/1/2025.
//


import SwiftUI
import CoreData


struct ExerciseListView: View {
    @StateObject private var viewModel: ExerciseViewModel
    
    init(viewModel: ExerciseViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello Exercies!")
    }
}

#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    let viewModel = ExerciseViewModel(moc: persistenceController.container.viewContext)

    ExerciseListView(viewModel: viewModel)
}
