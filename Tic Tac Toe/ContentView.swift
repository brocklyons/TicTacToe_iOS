//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Brock on 9/27/20.
//

import SwiftUI

enum GameMode {
    case singlePlayer
    case multiPlayer
}


// Main Menu for now
struct ContentView: View {
    var body: some View {
        
        NavigationView {
            
            ZStack {
                BackgroundView()
                
                VStack {
                    TitleView()

                    MenuButton(label: "1 Player", color: Color.green, load: AnyView(GameView(gameMode: GameMode.singlePlayer)), gameMode: GameMode.singlePlayer)
                    MenuButton(label: "2 Player", color: Color.purple, load: AnyView(GameView(gameMode: GameMode.multiPlayer)), gameMode: GameMode.multiPlayer)
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
    let gameMode: GameMode
    
    var body: some View {
        NavigationLink(
            destination: load,
            label: {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color.black.opacity(0.25))
                    
                    Spacer()
                    
                    Text(label)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    if gameMode == GameMode.singlePlayer {
                        Image(systemName: "desktopcomputer")
                            .foregroundColor(Color.black.opacity(0.25))
                    }
                    else {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color.black.opacity(0.25))
                    }
                    
                        
                }
                .padding()
                .frame(width: 200, height: 100, alignment: .center)
                .foregroundColor(.white)
                .background(color)
            })
            .cornerRadius(10)
            .animation(.easeInOut)
    }
}
