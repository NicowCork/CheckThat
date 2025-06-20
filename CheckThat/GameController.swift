//
//  GameController.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Swift
import Foundation

class GameController: ObservableObject {
    init(actual_move: String, moves: [Move], game: Game = Game()) {
        self.actual_move = actual_move
        self.game = game
    }
    
    @Published var actual_move: String
    @Published var game: Game
        
    func add_character(_ character: String) {
        actual_move.append(character)
    }
    func save_move(move: Move) {
        game.moves.append(Move(move_date: Date(), move: move.move))
        actual_move = ""
    }
}

