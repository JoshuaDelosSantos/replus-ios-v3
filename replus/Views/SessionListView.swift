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
    
    init(viewModel: SessionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
            .sheet(isPresented: $isShowingAddSessionSheet) {
                AddSessionView(viewModel: viewModel)
            }
        }
    }
}


#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    let viewModel = SessionViewModel(moc: persistenceController.container.viewContext)

    SessionListView(viewModel: viewModel)
}
