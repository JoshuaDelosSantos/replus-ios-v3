//
//  SessionListView.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//


import SwiftUI
import CoreData


/// Enum class for .sheets() - Allows dynamic sheets with 1 call.
enum SheetConfig: Int, Identifiable {
    var id: Int {return self.rawValue}
    
    case add
    case edit
}


struct SessionListView: View {
    @StateObject private var viewModel: SessionViewModel
    @State private var sheetConfig: SheetConfig?
    @State private var selectedSessionID: UUID? = nil
    @State private var isEditing: Bool = false
    @State private var showDeleteConfirmation: Bool = false

    init(viewModel: SessionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

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
                        // Check if there is a marked session
                        if hasMarkedSession() {
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
                            // Check if there is a marked session
                            if hasMarkedSession() {
                                deleteMarkedSession()
                                
                                viewModel.sessionToMark = nil
                                toggleEditMode()
                            }
                        },
                        secondaryButton: .cancel {
                            toggleEditMode()
                            viewModel.sessionToMark = nil
                        }
                    )
                }
        }
    }
    
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
                                displayRenameButton(session: session)
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
    
    private func displayRenameButton(session: Session) -> some View {
        Button(action: {}) {
            Image(systemName: "pencil")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
        .onTapGesture {
            print("SessionListView: Rename button pressed")  // Log
            markSessionWithID(id: session.id!)
            print("SessionListView: Session to update = \(String(describing: session.name))")  // Log
            
            sheetConfig = .edit
            toggleEditMode()
        }
    }
    
    private func displayDeleteButton(session: Session) -> some View {
        Button(action: {}) {
            Image(systemName: "trash")
                .foregroundColor(.red)
                .imageScale(.large)
        }
        .onTapGesture {
            print("SessionListView: Delete button pressed")  // Log
            let sessionID = session.id
            markSessionWithID(id: sessionID!)
            
            showDeleteConfirmation = true
            toggleEditMode()
        }
    }
    
    private func swipeDeleteSession(at offsets: IndexSet) {
        withAnimation {
            if let index = offsets.first {
                let sessionID = viewModel.sessions[index].id
                markSessionWithID(id: sessionID!)
                
                showDeleteConfirmation = true
            }
        }
    }
    
    /// Store a marked session in the viewModel.
    private func markSessionWithID(id: UUID) {
        viewModel.selectSession(id: id)
    }
    
    /// Delete the marked session in the viewModel.
    private func deleteMarkedSession() {
        viewModel.deleteSession()
    }
    
    /// Determines if there is a marked session in the viewModel.
    private func hasMarkedSession () -> Bool {
        viewModel.sessionToMark != nil
    }
    
}


#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    let viewModel = SessionViewModel(moc: persistenceController.container.viewContext)

    SessionListView(viewModel: viewModel)
}
