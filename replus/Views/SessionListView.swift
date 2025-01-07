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
                List(viewModel.sessions) { session in
                    Text("\(session.name ?? "Unamed Session") - Date: \(String(describing: session.modifiedAt))")
                }
                
                Button("Add") {
                    // Log
                    print("SessionListViewModel: Add button pressed")
                    viewModel.addSession(name: "New Session")
                }
            }
            .onAppear {
                viewModel.fetchSessions()
                
                // Log
                print("SessionListView: Fetched Sessions")
            }
        }
    }
}


#Preview {
    let persistenceController = PersistenceController(inMemory: true)

    SessionListView(moc: persistenceController.container.viewContext)
}
