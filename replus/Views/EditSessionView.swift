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
    @State private var selectedSessionName: String = ""
    @State private var newSessionName: String = ""
    @State private var isSaving = false
    
    init(viewModel: SessionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.selectedSessionName = viewModel.getSelectedSessionName()!
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rename session")) {
                    TextField("New Session Name", text: $newSessionName)
                }
            }
            .navigationTitle("Editing \(self.selectedSessionName) session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {await updateSession()}
                    }
                    .disabled(newSessionName.isEmpty || isSaving)
                }
            }
        }
    }
    
    private func updateSession() async {
        isSaving = true
        defer { isSaving = false}
        
        viewModel.updateSession(newName: newSessionName)
        print("EditSessionView: Updated session")  // Log
        
        presentationMode.wrappedValue.dismiss()
    }
    
}
