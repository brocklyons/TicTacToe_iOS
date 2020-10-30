//
//  GameView.swift
//  Tic Tac Toe
//
//  Created by Brock on 9/29/20.
//

import SwiftUI

// tracking the current play state
enum playState {
    case playerTurn
    case opponentTurn
    case playerWin
    case opponentWin
    case tiedGame
}

struct GameView: View {
    
    let gameMode: GameMode
    
    // Presentation mode we use for the back button to return to the main menu
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var currentPlayState = playState.playerTurn
    @State private var spaces = Array(repeating: 0, count: 9)
    @State private var spaceHighlighting = Array(repeating: 0, count: 9) // 0 - no highlight, 1 - green, 2 - red
    @State private var playAgainHidden = true
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            BackToMainMenuButton(presentationMode: presentationMode)

            VStack {
                TitleView()
                
                ZStack {
                    PlayerTurnBorder(currentPlayState: currentPlayState, gameMode: gameMode)

                    GameBoardView(
                        spaces: $spaces,
                        spaceHighlighting: $spaceHighlighting,
                        currentPlayState: $currentPlayState,
                        playAgainHidden: $playAgainHidden,
                        gameMode: gameMode)
                }
                
                PlayAgainButton(
                    spaces: $spaces,
                    spaceHighlighting: $spaceHighlighting,
                    currentPlayState: $currentPlayState,
                    playAgainHidden: $playAgainHidden)
                Spacer()
            }
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameMode: GameMode.singlePlayer)
    }
}


struct BackgroundView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color(red: 0/255, green: 94/255, blue: 189/255))
            .ignoresSafeArea()
        Rectangle()
            .foregroundColor(Color(red: 3/255, green: 132/255, blue: 252/255))
            .padding(.horizontal, 50)
            .ignoresSafeArea()
        Rectangle()
            .foregroundColor(Color(red: 92/255, green: 182/255, blue: 255/255))
            .padding(.horizontal, 100)
            .ignoresSafeArea()
    }
}


struct BackToMainMenuButton: View {
    
    @Binding var presentationMode: PresentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.$presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .resizable()
                        .frame(width: 50, height: 40, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .opacity(0.5)
                }
                .padding(.leading, 20)
                Spacer()
            }
            
            Spacer()
        }
    }
}


struct TitleView: View {
    var body: some View {
        // TODO: Replace this with a title graphic
        Text("Tic\n\t\tTac\n\t\t\t\tToe")
            .foregroundColor(.white)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .padding(.bottom, 50)
            .padding(.top, 100)
    }
}


struct PlayerTurnBorder: View {

    let currentPlayState: playState
    let gameMode: GameMode
    
    var body: some View {
        
        ZStack {
            if currentPlayState == playState.playerTurn ||
                currentPlayState == playState.playerWin {
                Rectangle()
                    .foregroundColor(.green)
                    .opacity(0.75)
                    .cornerRadius(30)
            }
            else if gameMode == GameMode.singlePlayer {
                if currentPlayState == playState.opponentTurn {
                    Rectangle()
                        .foregroundColor(.gray)
                        .opacity(0.75)
                        .cornerRadius(30)
                }
                else {
                    Rectangle()
                        .foregroundColor(.red)
                        .opacity(0.75)
                        .cornerRadius(30)
                }
            }
            else {
                if currentPlayState != playState.tiedGame {
                    Rectangle()
                        .foregroundColor(.purple)
                        .opacity(0.75)
                        .cornerRadius(30)
                }
                else {
                    Rectangle()
                        .foregroundColor(.gray)
                        .opacity(0.75)
                        .cornerRadius(30)
                }
            }
            
            VStack {
                Spacer()
                
                if gameMode == GameMode.singlePlayer {
                    if currentPlayState == playState.playerTurn {
                        StateLabel(label: "Your turn")
                    }
                    else if currentPlayState == playState.opponentTurn {
                        StateLabel(label: "Opponent's turn")
                    }
                    // Game is over, display a result and play again button
                    else {
                        // Player wins
                        if currentPlayState == playState.playerWin {
                            StateLabel(label: "You win!")
                        }
                        // Opponent wins
                        else if currentPlayState == playState.opponentWin {
                            StateLabel(label: "You lose!")
                        }
                        else if currentPlayState == playState.tiedGame {
                            StateLabel(label: "Tied game!")
                        }
                    }
                }
                else {
                    if currentPlayState == playState.playerTurn {
                        StateLabel(label: "X's Turn")
                    }
                    else if currentPlayState == playState.opponentTurn {
                        StateLabel(label: "O's Turn")
                    }
                    // Game is over, display a result and play again button
                    else {
                        // Player wins
                        if currentPlayState == playState.playerWin {
                            StateLabel(label: "X Wins!")
                        }
                        // Opponent wins
                        else if currentPlayState == playState.opponentWin {
                            StateLabel(label: "O Wins!")
                        }
                        else if currentPlayState == playState.tiedGame {
                            StateLabel(label: "Tied game!")
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .aspectRatio(1.0, contentMode: .fit)
    }
}


struct StateLabel: View {
    
    let label: String
    
    var body: some View {
        Text(label)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
}


struct GameBoardView: View {
    
    @Binding var spaces: Array<Int>
    @Binding var spaceHighlighting: Array<Int>
    @Binding var currentPlayState: playState
    @Binding var playAgainHidden: Bool
    
    let gameMode: GameMode
    
    let rowIndices = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8]
    ]
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.5)
                .cornerRadius(30)
                .hidden()
            
            VStack {
                ForEach(rowIndices, id: \.self) { row in
                    BoardRowView(
                        spaces: $spaces,
                        spaceHighlighting: $spaceHighlighting,
                        currentPlayState: $currentPlayState,
                        playAgainHidden: $playAgainHidden,
                        gameMode: gameMode,
                        rowIndices: row)
                }
            }
        }
        .padding(.horizontal, 20)
        .aspectRatio(1.0, contentMode: .fit)
    }
}


struct BoardRowView: View {
    
    @Binding var spaces: Array<Int>
    @Binding var spaceHighlighting: Array<Int>
    @Binding var currentPlayState: playState
    @Binding var playAgainHidden: Bool
    let gameMode: GameMode
    let rowIndices: Array<Int>
    
    var body: some View {
        HStack {
            ForEach(rowIndices, id: \.self) { index in
                MoveSpace(
                    spaces: $spaces,
                    spaceHighlighting: $spaceHighlighting,
                    currentPlayState: $currentPlayState,
                    playAgainHidden: $playAgainHidden,
                    thisSpace: index,
                    gameMode: gameMode)
            }
        }.padding(.horizontal, 10)
    }
}


struct PlayAgainButton: View {
    
    @Binding var spaces: Array<Int>
    @Binding var spaceHighlighting: Array<Int>
    @Binding var currentPlayState: playState
    @Binding var playAgainHidden: Bool
    
    var body: some View {
        Text("Play again")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .isHidden(playAgainHidden)
            .onTapGesture(perform: {
                // Reset the board and start the player's turn
                spaces = Array(repeating: 0, count: 9)
                spaceHighlighting = Array(repeating: 0, count: 9)
                currentPlayState = playState.playerTurn
                playAgainHidden = true
            })
    }
}


extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
