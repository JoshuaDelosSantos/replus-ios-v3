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
    @State private var isShowingAddSessionSheet: Bool = false
    
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
                    }
                }
            }
            .navigationTitle("Sessions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {isShowingAddSessionSheet = true}) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.fetchSessions()
                print("SessionListView: Fetched Sessions")  // Log
            }
            .sheet(isPresented: $isShowingAddSessionSheet) {
                AddSessionView(moc: moc)
            }
        }
    }
}


#Preview {
    let persistenceController = PersistenceController(inMemory: true)

    SessionListView(moc: persistenceController.container.viewContext)
}
