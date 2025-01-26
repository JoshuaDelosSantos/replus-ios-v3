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
        NavigationView {
            VStack {
                if viewModel.exercises .isEmpty {
                    Text("No exercises available")
                        .foregroundColor(.gray)  // Theme
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.exercises, id: \.id) { exercise in
                            HStack {
                                Text("\(String(describing: exercise.name))")
                            }
                        }
                    }
                }
            } // VStack
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Label("Add", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Text("Edit")
                    }
                }
            }
        } // NavigationView
    }
}

#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    let viewModel = ExerciseViewModel(moc: persistenceController.container.viewContext)

    ExerciseListView(viewModel: viewModel)
}
