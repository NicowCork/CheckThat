//
//  GameController.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Foundation
import AVFoundation

class GameController: ObservableObject {
    init(actual_move: String = "...", game: Game = Game(), isPairComplete: Bool = true) {
        self.actual_move = actual_move
        self.game = game
        self.isPairComplete = isPairComplete
    }
    
    @Published var actual_move: String {
        willSet {
            ControlButtons(forInput: newValue)
        }
    }
    @Published var game: Game
    @Published var isPairComplete: Bool
    @Published var coup_saved: Move = Move(move_date: Date(), move: "")
    @Published var move_validation: ButtonsControllerState = .start_default
    
    func ControlButtons(forInput input: String) {
        if input.matches(movesRegexes.start_default.rawValue) {
            print("...")
            move_validation = .start_default
            return
        }
        if input.matches(movesRegexes.pawn.rawValue) {
            print("only file")
            move_validation = .pawn
            return
        }
        if input.matches(movesRegexes.pawn_rank.rawValue) {
            print("pawn rank ")
            move_validation = .pawn_rank
            return
        }
        if input.matches(movesRegexes.pawn_taking_file.rawValue) {
            print("pawn taking")
            move_validation = .pawn_taking_file
            return
        }
        if input.matches(movesRegexes.pawn_taking_file_rank.rawValue) {
            print("pawn taking file")
            move_validation = .pawn_taking_file_rank
            return
        }
        if input.matches(movesRegexes.pawn_promotion.rawValue) {
            print("pawn promotion")
            move_validation = .pawn_promotion
            return
        }
        if input.matches(movesRegexes.pawn_promotion_check.rawValue) {
            print("pawn promotion check")
            move_validation = .pawn_promotion_check
            return
        }
        if input.matches(movesRegexes.piece.rawValue) {
            print("piece")
            move_validation = .piece
            return
        }
        if input.matches(movesRegexes.piece_file.rawValue) {
            print("piece file")
            move_validation = .piece_file
            return
        }
        if input.matches(movesRegexes.piece_file_rank.rawValue) {
            print("piece file rank")
            move_validation = .piece_file_rank
            return
        }
        if input.matches(movesRegexes.piece_moving.rawValue) {
            print("piece moving")
            move_validation = .piece_moving
            return
        }
        if input.matches(movesRegexes.piece_taking.rawValue) {
            print("piece taking")
            move_validation = .piece_taking
            return
        }
        if input.matches(movesRegexes.piece_taking_file.rawValue) {
            print("piece taking file")
            move_validation = .piece_taking_file
            return
        }
        if input.matches(movesRegexes.piece_taking_file_rank.rawValue) {
            print("piece taking file rank")
            move_validation = .piece_taking_file_rank
            return
        }
        if input.matches(movesRegexes.piece_taking_check.rawValue) {
            print("piece taking check")
            move_validation = .piece_taking_check
            return
        }
        if input.matches(movesRegexes.all_rocks.rawValue) {
            print("All rocks")
            move_validation = .all_rocks
            return
        }
        if input.matches(movesRegexes.full_move.rawValue) {
            print("full move")
            move_validation = .full_move
            return
        }
    }
        
    func add_character(_ character: String) {
        if actual_move == "..." {
            actual_move = character
        } else {
            actual_move.append(character)
        }
    }
    
    func remove_last() {
        if actual_move == "..." {
            playSound(sound: "Pouet", type: "mp3")
        } else if actual_move.count == 1 {
            actual_move = "..."
        } else {
            actual_move.removeLast()
        }
    }
    
    func save_pair(withMoveSaved move_saved: Move, andMove move: Move) {
        game.moves.append(PairMove(move_one: move_saved, move_two: move))
        actual_move = "..."
        isPairComplete = true
    }
    
    func save_move(move: Move) {
        if actual_move.count < 2 || actual_move.isEmpty || actual_move.count > 7 {
            playSound(sound: "Pouet", type: "mp3")
            print("Coup non valide")
        } else {
            coup_saved = move
            actual_move = "..."
            isPairComplete = false
        }
    }
}

