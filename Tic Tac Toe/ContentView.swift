//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Brock on 9/27/20.
//

import SwiftUI


// Main Menu for now
struct ContentView: View {
    var body: some View {
        
        NavigationView {
            
            ZStack {
                BackgroundView()
                
                VStack {
                    TitleView()

                    MenuButton(label: "Single Player", color: Color.green, load: AnyView(GameView()))
                    MenuButton(label: "Multiplayer", color: Color.gray, load: AnyView(GameView()))
                    Spacer()
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MenuButton: View {
    
    let label: String
    let color: Color
    let load: AnyView
    
    var body: some View {
        NavigationLink(
            destination: load,
            label: {
                Text(label)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(width: 200, height: 100, alignment: .center)
                    .foregroundColor(.white)
                    .background(color)
            })
            .cornerRadius(10)
            .animation(.easeInOut)
    }
}
