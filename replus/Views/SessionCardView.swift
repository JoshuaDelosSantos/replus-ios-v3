//
//  SessionCardView.swift
//  replus
//
//  Created by Joshua Delos Santos on 8/1/2025.
//



import SwiftUI


struct SessionCardView: View {
    let session: Session
    
    var body: some View {
        Text(session.name ?? "Unamed Session")
            .font(.headline)
            .padding()
            .onAppear {
                //Log
                print("SessionCardView: Session ID: \(String(describing: session.id)), Name: \(session.name ?? "Unnamed")")
            }
    }
}
