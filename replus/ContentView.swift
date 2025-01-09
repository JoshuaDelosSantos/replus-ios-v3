//
//  ContentView.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//


import SwiftUI
import CoreData


struct ContentView: View {
    private let moc: NSManagedObjectContext
    
    @StateObject private var viewModel: SessionViewModel
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        _viewModel = StateObject(wrappedValue: SessionViewModel(moc: moc))
    }
    
    var body: some View {
        SessionListView(viewModel: viewModel)
    }
}

#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    let moc = persistenceController.container.viewContext
    
    ContentView(moc: moc)
}
