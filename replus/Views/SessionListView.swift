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
    @State private var showDeleteConfirmation: Bool = false

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
                        if viewModel.sessionToMark != nil {
                            EditSessionView(viewModel: viewModel)
                        } else {
                            // Fallback UI if `selectedSession` is nil
                            Text("No session selected for editing.")
                        }
                    }
                })
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Delete Session"),
                        message: Text("Are you sure you want to delete this session? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            if viewModel.sessionToMark != nil {
                                viewModel.deleteSession()
                                viewModel.sessionToMark = nil
                            }
                        },
                        secondaryButton: .cancel {
                            viewModel.sessionToMark = nil
                        }
                    )
                }
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
                List {
                    ForEach(viewModel.sessions, id: \.id) { session in
                        HStack {
                            if isEditing {
                                displayDeleteButton(session: session)
                                    .padding(.trailing, 8)
//                                displayRenameButton(session: session)
                            }
                            SessionCardView(session: session)
                        }
                    }
                    .onDelete(perform: swipeDeleteSession)
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
            print("SessionListView: Rename button pressed")  // Log
            viewModel.selectSession(id: session.id!)
            print("SessionListView: Session to update = \(String(describing: session.name))")  // Log
            
            sheetConfig = .edit
            toggleEditMode()
        }) {
            Image(systemName: "pencil")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
    
// MARK: - Edit (Delete Button)
    private func displayDeleteButton(session: Session) -> some View {
        Button(action: {
            print("SessionListView: Delete button pressed")  // Log
            let sessionID = session.id
            viewModel.selectSession(id: sessionID!)
            showDeleteConfirmation = true
            
            toggleEditMode()
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
                .imageScale(.large)
        }
    }
    
// MARK: - Delete Session
    private func swipeDeleteSession(at offsets: IndexSet) {
        withAnimation {
            if let index = offsets.first {
                let sessionID = viewModel.sessions[index].id
                viewModel.selectSession(id: sessionID!)
                showDeleteConfirmation = true
            }
        }
    }
    
}


#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    let viewModel = SessionViewModel(moc: persistenceController.container.viewContext)

    SessionListView(viewModel: viewModel)
}
