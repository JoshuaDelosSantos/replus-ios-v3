//
//  AddSessionView.swift
//  replus
//
//  Created by Joshua Delos Santos on 8/1/2025.
//


import SwiftUI
import CoreData


struct AddSessionView: View {
    let moc: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: SessionViewModel
    @State private var sessionName: String = ""
    @State private var isSaving = false
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        _viewModel = StateObject(wrappedValue: SessionViewModel(moc: moc))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Session Details")) {
                    TextField("Session Name", text: $sessionName)
                }
                if isSaving {
                    ProgressView("Saving...")
                        .padding()
                }
            }
            .navigationTitle("Add Session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {await addSession()}
                    }
                    .disabled(sessionName.isEmpty || isSaving)
                }
            }
        }
    }
    
    private func addSession() async {
        isSaving = true
        defer { isSaving = false}
        
        viewModel.addSession(name: sessionName)
        
        print("AddSessionView: Added session")  // Log
    }
}


#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    
    AddSessionView(moc: persistenceController.container.viewContext)
}
