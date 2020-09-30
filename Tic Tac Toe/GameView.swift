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
    @State private var currentPlayState = playState.playerTurn
    @State private var spaces = Array(repeating: 0, count: 9)
    @State private var playAgainHidden = true
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            VStack {
                TitleView()
                
                ZStack {
                    PlayerTurnBorder(currentPlayState: currentPlayState)

                    GameBoardView(
                        spaces: $spaces,
                        currentPlayState: $currentPlayState,
                        playAgainHidden: $playAgainHidden)
                }
                
                PlayAgainButton(
                    spaces: $spaces,
                    currentPlayState: $currentPlayState,
                    playAgainHidden: $playAgainHidden)
            }
        }
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


struct TitleView: View {
    var body: some View {
        // TODO: Replace this with a title graphic
        Text("Tic\n\t\tTac\n\t\t\t\tToe")
            .foregroundColor(.white)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .padding(.bottom, 50)
    }
}


struct PlayerTurnBorder: View {

    let currentPlayState: playState
    
    var body: some View {
        
        ZStack {
            if currentPlayState == playState.playerTurn ||
                currentPlayState == playState.playerWin {
                Rectangle()
                    .foregroundColor(.green)
                    .opacity(0.75)
                    .cornerRadius(30)
            }
            else if currentPlayState == playState.opponentTurn {
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
            
            VStack {
                Spacer()
                
                if currentPlayState == playState.playerTurn {
                    StateLabel(label: "Your turn", color: Color.green)
                }
                else if currentPlayState == playState.opponentTurn {
                    StateLabel(label: "Opponent's turn", color: Color.gray)
                }
                // Game is over, display a result and play again button
                else {
                    // Player wins
                    if currentPlayState == playState.playerWin {
                        StateLabel(label: "You win!", color: Color.green)
                    }
                    // Opponent wins
                    else if currentPlayState == playState.opponentWin {
                        StateLabel(label: "You lose!", color: Color.red)
                    }
                    else if currentPlayState == playState.tiedGame {
                        StateLabel(label: "Tied game!", color: Color.red)
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
    let color: Color
    
    var body: some View {
        Text(label)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.0))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
    }
}


struct GameBoardView: View {
    
    @Binding var spaces: Array<Int>
    @Binding var currentPlayState: playState
    @Binding var playAgainHidden: Bool
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.5)
                .cornerRadius(30)
                .hidden()
            
            VStack {
                BoardRowView(
                    spaces: $spaces,
                    currentPlayState: $currentPlayState,
                    playAgainHidden: $playAgainHidden,
                    rowIndices: [0, 1 ,2])
                BoardRowView(
                    spaces: $spaces,
                    currentPlayState: $currentPlayState,
                    playAgainHidden: $playAgainHidden,
                    rowIndices: [3, 4 ,5])
                BoardRowView(
                    spaces: $spaces,
                    currentPlayState: $currentPlayState,
                    playAgainHidden: $playAgainHidden,
                    rowIndices: [6, 7 ,8])
            }
        }
        .padding(.horizontal, 20)
        .aspectRatio(1.0, contentMode: .fit)
    }
}


struct BoardRowView: View {
    
    @Binding var spaces: Array<Int>
    @Binding var currentPlayState: playState
    @Binding var playAgainHidden: Bool
    let rowIndices: Array<Int>
    
    var body: some View {
        HStack {
            MoveSpace(
                spaces: $spaces,
                currentPlayState: $currentPlayState,
                playAgainHidden: $playAgainHidden,
                thisSpace: rowIndices[0])
            MoveSpace(
                spaces: $spaces,
                currentPlayState: $currentPlayState,
                playAgainHidden: $playAgainHidden,
                thisSpace: rowIndices[1])
            MoveSpace(
                spaces: $spaces,
                currentPlayState: $currentPlayState,
                playAgainHidden: $playAgainHidden,
                thisSpace: rowIndices[2])
        }.padding(.horizontal, 10)
    }
}


struct PlayAgainButton: View {
    
    @Binding var spaces: Array<Int>
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

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
