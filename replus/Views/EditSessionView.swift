//
//  EditSessionView.swift
//  replus
//
//  Created by Joshua Delos Santos on 9/1/2025.
//


import SwiftUI
import CoreData


struct EditSessionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: SessionViewModel
    @State private var sessionName: String = ""
    
    init(viewModel: SessionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Edit")
    }
    
}


#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    let viewModel = SessionViewModel(moc: persistenceController.container.viewContext)
    
    EditSessionView(viewModel: viewModel)
}
