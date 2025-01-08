//
//  SessionListView.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//


import SwiftUI
import CoreData


struct SessionListView: View {
    let moc: NSManagedObjectContext
    
    @StateObject private var viewModel: SessionViewModel
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        _viewModel = StateObject(wrappedValue: SessionViewModel(moc: moc))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // No sessions
                if viewModel.sessions.isEmpty {
                    Text("No sessions available")
                        .foregroundColor(.gray)  // Theme
                        .padding()
                } else {
                    List(viewModel.sessions) { session in
                        SessionCardView(session: session)
                            .padding()
                    }
                }
            }
            .navigationTitle("Sessions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {addSession()}) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.fetchSessions()
                print("SessionListView: Fetched Sessions")  // Log
            }
        }
    }
    
    
    private func addSession(name: String = "Unknown Session") {
        print("SessionListViewModel: Add button pressed")  // Log
        viewModel.addSession(name: name)
    }
}


#Preview {
    let persistenceController = PersistenceController(inMemory: true)

    SessionListView(moc: persistenceController.container.viewContext)
}
