//
//  GameController.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Foundation

class GameController: ObservableObject {
    init(actual_move: String = "???", game: Game = Game()) {
        self.actual_move = actual_move
        self.game = game
    }
    
    @Published var actual_move: String
    var game: Game
        
    func add_character(_ character: String) {
        actual_move.append(character)
    }
    
    func save_move(move: Move) {
        if actual_move.count < 2 || actual_move.isEmpty || actual_move.count > 7 {
            print("Coup non valide")
        } else {
            game.moves.append(Move(move_date: Date(), move: move.move))
            actual_move = "???"
        }
    }
}

