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
                        .resizable()
                        .foregroundColor(Color.black.opacity(0.25))
                        .frame(width: 30, height: 30, alignment: .center)

                    Spacer()
                    
                    Text(label)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    if gameMode == GameMode.singlePlayer {
                        Image(systemName: "desktopcomputer")
                            .resizable()
                            .foregroundColor(Color.black.opacity(0.25))
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                    else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .foregroundColor(Color.black.opacity(0.25))
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                }
                .padding()
                .frame(width: 250, height: 115, alignment: .center)
                .foregroundColor(.white)
                .background(color)
            })
            .cornerRadius(10)
            .animation(.easeInOut)
            .padding(.bottom)
    }
}
