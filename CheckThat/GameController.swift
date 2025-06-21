//
//  GameController.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Foundation

class GameController: ObservableObject {
    init(actual_move: String = "", game: Game = Game(), isPairComplete: Bool = true) {
        self.actual_move = actual_move
        self.game = game
        self.isPairComplete = isPairComplete
    }
    
    @Published var actual_move: String
    @Published var game: Game
    @Published var isPairComplete: Bool
    @Published var coup_saved: Move = Move(move_date: Date(), move: "")
    
        
    func add_character(_ character: String) {
            actual_move.append(character)
    }
    
    func delete_last() {
        if actual_move.isEmpty {
            print("pouet")
        } else {
            actual_move.removeLast()
        }
    }
    
    func save_pair(withMoveSaved move_saved: Move, andMove move: Move) {
        game.moves.append(PairMove(move_one: move_saved, move_two: move))
        actual_move = ""
        isPairComplete = true
    }
    
    func save_move(move: Move) {
        if actual_move.count < 2 || actual_move.isEmpty || actual_move.count > 7 {
            print("Coup non valide")
        } else {
            coup_saved = move
            actual_move = ""
            isPairComplete = false
        }
    }
}

