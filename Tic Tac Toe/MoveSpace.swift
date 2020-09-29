//
//  MoveSpace.swift
//  Tic Tac Toe
//
//  Created by Brock on 9/27/20.
//

import SwiftUI

struct MoveSpace: View {
    
    @Binding var spaces: Array<Int>
    @Binding var currentPlayState: playState
    @Binding var playAgainHidden: Bool
    let thisSpace:Int
    
    var symbols = ["", "multiply", "circle"]
    
    var body: some View {
        
        Image(systemName: symbols[spaces[thisSpace]])
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .aspectRatio(1.0, contentMode: .fit)
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            .padding(5)
            .foregroundColor(.black)
            .onTapGesture(count: 1, perform: {
                // Cannot make the a move on a taken space or if the game is over
                if spaces[thisSpace] == 0 &&
                    (currentPlayState == playState.playerTurn ||
                     currentPlayState == playState.opponentTurn) {
                    
                    if !makeMove() && !spaces.contains(0) {
                        currentPlayState = playState.tiedGame
                    }
                }
            })
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
            return true
        }
        
        // Check column
        if spaces[col] == piece &&
            spaces[col + 3] == piece &&
            spaces[col + 6] == piece {
            return true
        }
        
        // Check diagonals
        if space % 2 == 0 { // if space was even, it was on a diagonal
            if (spaces[0] == piece &&
                spaces[4] == piece &&
                spaces[8] == piece) ||
               (spaces[2] == piece &&
                spaces[4] == piece &&
                spaces[6] == piece) {
                return true
            }
        }
        
        return false // no winning layouts were found with the last played space
    }
}

struct MoveSpace_Previews: PreviewProvider {
    static var previews: some View {
        MoveSpace(
            spaces: Binding.constant([0,1,2]),
            currentPlayState: Binding.constant(playState.playerTurn),
            playAgainHidden: Binding.constant(true),
            thisSpace: 0)
    }
}
