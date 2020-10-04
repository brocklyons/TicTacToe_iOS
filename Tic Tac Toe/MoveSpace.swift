//
//  MoveSpace.swift
//  Tic Tac Toe
//
//  Created by Brock on 9/27/20.
//

import SwiftUI

struct MoveSpace: View {
    
    @Binding var spaces: Array<Int>
    @Binding var spaceHighlighting: Array<Int>
    @Binding var currentPlayState: playState
    @Binding var playAgainHidden: Bool
    
    let thisSpace:Int
    let gameMode: GameMode
    let symbols = ["", "multiply", "circle"]
    
    var body: some View {
        
        if spaceHighlighting[thisSpace] == 0 {
            // no highlight
            SpaceView(spaces: $spaces,
                      currentPlayState: $currentPlayState,
                      spaceHighlighting: $spaceHighlighting,
                      playAgainHidden: $playAgainHidden,
                      thisSpace: thisSpace,
                      gameMode: gameMode,
                      symbols: symbols,
                      spaceColor: Color.white.opacity(0.5),
                      highlightColor: Color.white.opacity(0.0))
        }
        else if spaceHighlighting[thisSpace] == 1 {
            // green highlight
            SpaceView(spaces: $spaces,
                      currentPlayState: $currentPlayState,
                      spaceHighlighting: $spaceHighlighting,
                      playAgainHidden: $playAgainHidden,
                      thisSpace: thisSpace,
                      gameMode: gameMode,
                      symbols: symbols,
                      spaceColor: Color.green,
                      highlightColor: Color.white)
        }
        else if spaceHighlighting[thisSpace] == 2 {
            // red highlight
            SpaceView(spaces: $spaces,
                      currentPlayState: $currentPlayState,
                      spaceHighlighting: $spaceHighlighting,
                      playAgainHidden: $playAgainHidden,
                      thisSpace: thisSpace,
                      gameMode: gameMode,
                      symbols: symbols,
                      spaceColor: Color.red,
                      highlightColor: Color.white)
        }
    }
}

struct MoveSpace_Previews: PreviewProvider {
    static var previews: some View {
        MoveSpace(
            spaces: Binding.constant([0,1,2]),
            spaceHighlighting: Binding.constant([0,1,2]),
            currentPlayState: Binding.constant(playState.playerTurn),
            playAgainHidden: Binding.constant(true),
            thisSpace: 0,
            gameMode: GameMode.singlePlayer)
    }
}

struct SpaceView: View {
    
    @Binding var spaces: Array<Int>
    @Binding var currentPlayState: playState
    @Binding var spaceHighlighting: Array<Int>
    @Binding var playAgainHidden: Bool
    
    let thisSpace: Int
    let gameMode: GameMode
    let symbols: Array<String>
    
    let spaceColor: Color
    let highlightColor: Color
    
    var body: some View {
        
        Image(systemName: symbols[spaces[thisSpace]])
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .aspectRatio(1.0, contentMode: .fit)
            .background(spaceColor)
            .border(highlightColor, width: 5)
            .cornerRadius(10)
            .padding(5)
            .foregroundColor(.black)
            .onTapGesture(count: 1, perform: {
                // Cannot make the a move on a taken space or if the game is over
                if spaces[thisSpace] == 0 &&
                    (currentPlayState == playState.playerTurn ||
                        (currentPlayState == playState.opponentTurn && gameMode == GameMode.multiPlayer)) {
                    
                    if !makeMove() && !spaces.contains(0) {
                        currentPlayState = playState.tiedGame
                        playAgainHidden = false
                    }
                    
                    // AI makes a move after the player goes
                    if gameMode == GameMode.singlePlayer && currentPlayState == playState.opponentTurn {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            // We need to now make an AI move
                            let moveIndex = findMoveAI(spaces)
                            if moveIndex != -1 {
                                spaces[moveIndex] = 2
                            }
                            
                            // Determine whether the AI has just won or not
                            if calculateBoard(false, moveIndex) {
                                // AI won, load AI winning end game
                                currentPlayState = playState.opponentWin
                                playAgainHidden = false
                            }
                            else if spaces.contains(0) {
                                // AI did not win yet, player's turn
                                currentPlayState = playState.playerTurn
                            }
                            else {
                                // No spaces left and no winnder, tied game
                                currentPlayState = playState.tiedGame
                                playAgainHidden = false
                            }
                        }
                    }
                }
            })
    }
    
    func findMoveAI(_ spaces: Array<Int>) -> Int {
        
        var availableSpaces = [Int]()
        for (index, element) in spaces.enumerated() {
            if element == 0 {
                availableSpaces.append(index)
            }
        }
        
        if availableSpaces.count != 0 {
            return availableSpaces[0] // <--------- For now just returning the fist availbe space, this should be more smart later
        }
        else {
            return -1
        }
    }
    
    
    func makeMove() -> Bool {
        // Player's turn
        if currentPlayState == playState.playerTurn {
            spaces[thisSpace] = 1
            if calculateBoard(true, thisSpace) {
                currentPlayState = playState.playerWin
                playAgainHidden = false
                return true
            }
            else {
                currentPlayState = playState.opponentTurn
                return false
            }
        }
        // Opponent's turn
        else if currentPlayState == playState.opponentTurn {
            spaces[thisSpace] = 2
            if calculateBoard(false, thisSpace) {
                currentPlayState = playState.opponentWin
                playAgainHidden = false
                return true
            }
            else {
                currentPlayState = playState.playerTurn
                return false
            }
        }
        return false
    }
    
    
    func calculateBoard(_ isPlayer:Bool, _ space:Int) -> Bool {
        // Calculate the row and column of the given space
        let row = ((space - (space % 3)) / 3) // gives 0, 1, or 2 as the row
        let col = (space % 3) // gives 0, 1, or 2 as the column
        
        var piece = 1
        if !isPlayer {
            piece = 2
        }
        
        // Check row
        let startingIndex = row * 3
        if spaces[startingIndex] == piece &&
            spaces[startingIndex + 1] == piece &&
            spaces[startingIndex + 2] == piece {
            
            // Set highlights and change this cell if highlighted
            spaceHighlighting[startingIndex] = piece
            spaceHighlighting[startingIndex + 1] = piece
            spaceHighlighting[startingIndex + 2] = piece
            
            return true
        }
        
        // Check column
        if spaces[col] == piece &&
            spaces[col + 3] == piece &&
            spaces[col + 6] == piece {
            
            // Set highlights and change this cell if highlighted
            spaceHighlighting[col] = piece
            spaceHighlighting[col + 3] = piece
            spaceHighlighting[col + 6] = piece
            
            return true
        }
        
        // Check diagonals
        if space % 2 == 0 { // if space was even, it was on a diagonal
            
            if spaces[0] == piece &&
                spaces[4] == piece &&
                spaces[8] == piece {
                
                // Set highlights and change this cell if highlighted
                spaceHighlighting[0] = piece
                spaceHighlighting[4] = piece
                spaceHighlighting[8] = piece
                
                return true
            }
            else if spaces[2] == piece &&
                    spaces[4] == piece &&
                    spaces[6] == piece {
                
                // Set highlights and change this cell if highlighted
                spaceHighlighting[2] = piece
                spaceHighlighting[4] = piece
                spaceHighlighting[6] = piece
                
                return true
            }
        }
        
        return false // no winning layouts were found with the last played space
    }
}
