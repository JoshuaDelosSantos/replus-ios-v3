//
//  ContentView.swift
//  replus
//
//  Created by Joshua Delos Santos on 6/1/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        SessionListView(moc: moc)
    }
}

#Preview {
    ContentView()
}
