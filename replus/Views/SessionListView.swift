//
//  SessionListView.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//


import SwiftUI
import CoreData


struct SessionListView: View {
    
    @StateObject private var viewModel: SessionViewModel
    @State private var isShowingAddSessionSheet: Bool = false
    @State private var isEditing: Bool = false
    @State private var isShowingEditSessionSheet: Bool = false
    
    init(viewModel: SessionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            displaySessions()
            .navigationTitle("Sessions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {isShowingAddSessionSheet = true}) {
                        Label("Add", systemImage: "plus")
                    }
                }
    
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {toggleEditMode()}) {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddSessionSheet) {
                AddSessionView(viewModel: viewModel)
            }
            .sheet(isPresented: $isShowingEditSessionSheet) {
                EditSessionView(viewModel: viewModel)
            }
        }
    }
    
    private func displaySessions() -> some View {
        VStack {
            // No sessions
            if viewModel.sessions.isEmpty {
                Text("No sessions available")
                    .foregroundColor(.gray)  // Theme
                    .padding()
            } else {
                List(viewModel.sessions) { session in
                    HStack {
                        if isEditing {
                            displayRenameButton()
                        }
                        SessionCardView(session: session)
                    }
                }
            }
        }
    }
    
    private func toggleEditMode() {
            isEditing.toggle()
    }
    
    private func displayRenameButton() -> some View {
        Button(action: {isShowingEditSessionSheet = true}) {
            Image(systemName: "pencil")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
    
}


#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    let viewModel = SessionViewModel(moc: persistenceController.container.viewContext)

    SessionListView(viewModel: viewModel)
}
