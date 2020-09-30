//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Brock on 9/27/20.
//

import SwiftUI


// Main View containing all subviews - keep this light
struct ContentView: View {
    var body: some View {
        
        NavigationView {
            NavigationLink(
                destination: GameView(),
                label: {
                    Text("Play")
                })
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
