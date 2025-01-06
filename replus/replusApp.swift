//
//  replusApp.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//

import SwiftUI

@main
struct replusApp: App {
    @StateObject private var persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
