//
//  SessionCardView.swift
//  replus
//
//  Created by Joshua Delos Santos on 8/1/2025.
//



import SwiftUI


struct SessionCardView: View {
    let session: Session
    let sessionName: String
    
    init(session: Session) {
        self.session = session
        self.sessionName = session.name ?? "Unknown Session"
    }
    
    var body: some View {
        Text(sessionName)
            .font(.headline)
            .padding()
            .onAppear {
                print("SessionCardView: Session ID: \(String(describing: session.id)), Name: \(session.name ?? "Unnamed")")  //Log
            }
    }
}
