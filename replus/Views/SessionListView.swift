//
//  SessionListView.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//


import SwiftUI
import CoreData


// MARK: - Enum for .sheets().
enum SheetConfig: Int, Identifiable {
    var id: Int {return self.rawValue}
    
    case add
    case edit
}

struct SessionListView: View {
// MARK: - Variables
    @StateObject private var viewModel: SessionViewModel
    @State private var sheetConfig: SheetConfig?
    @State private var selectedSessionID: UUID? = nil
    @State private var isEditing: Bool = false

// MARK: - Initialiser.
    init(viewModel: SessionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

// MARK: - Main.
    var body: some View {
        NavigationView {
            displaySessions()
                .navigationTitle("Sessions")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            sheetConfig = .add
                        }) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { toggleEditMode() }) {
                            Text(isEditing ? "Done" : "Edit")
                        }
                    }
                }
                .sheet(item: $sheetConfig, content:  { config in
                    switch config {
                    case .add:
                        AddSessionView(viewModel: viewModel)
                    case .edit:
                        if viewModel.sessionToUpdate != nil {
                            EditSessionView(viewModel: viewModel)
                        } else {
                            // Fallback UI if `selectedSession` is nil
                            Text("No session selected for editing.")  // Log
                        }
                    }
                })
        }
    }
    
// MARK: - Display Sessions.
    private func displaySessions() -> some View {
        VStack {
            if viewModel.sessions.isEmpty {
                Text("No sessions available")
                    .foregroundColor(.gray)  // Theme
                    .padding()
            } else {
                List(viewModel.sessions) { session in
                    HStack {
                        if isEditing {
                            displayRenameButton(session: session)
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
    
// MARK: - Edit (Rename Button)
    private func displayRenameButton(session: Session) -> some View {
        Button(action: {
            viewModel.selectSession(id: session.id!)
            print("SessionListView: selectedSession = \(String(describing: session.name))")  // Log
            
            sheetConfig = .edit
        }) {
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
