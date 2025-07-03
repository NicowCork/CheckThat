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
            buttonsController.ControlButtons(forInput: newValue)
        }
    }
    @Published var game: Game
    @Published var isPairComplete: Bool
    @Published var isGameFinished: Bool = false
    @Published var coup_saved: Move = Move(move: "...")
    @Published var buttonsController: ButtonsController = ButtonsController()
    
    @Published var result: String = ""
    
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
    
    func save_pair(withMoveSaved: Move, andMove move: Move) {
        let pairId: Int = game.id_ + 1
        game.pair_Moves.append(PairMove(id_: pairId, move_one: coup_saved, move_two: move))
        
        if game.pair_Moves.last?.move_one.move.last == "#" {
            result = "1-0"
        } else if game.pair_Moves.last?.move_two.move.last == "#" {
            result = "0-1"
        }
        
        if actual_move.last == "#" {
            isGameFinished = true
        } else {
            game.id_ += 1
            actual_move = "..."
            isPairComplete = true
        }
    }
    
    func save_move(move: Move) {
        if actual_move.last == "#" {
            coup_saved = move
            save_pair(withMoveSaved: move, andMove: Move(move: ""))
        } else {
            coup_saved = move
            actual_move = "..."
            isPairComplete = false
        }
    }
    
    func newGame() {
        actual_move = "..."
        result = ""
        self.game = Game()
        self.isPairComplete = true
        self.isGameFinished = false
        self.coup_saved = Move(move: "...")
    }
    
    func getPGNContent(forWhite white: String, andBlack black : String, result: String, event: String?, site: String?, blackElo: String?, whiteElo: String?) -> String {
        var pgn_moves = ""
        for moves in game.pair_Moves {
            let move = "\(moves.id_).\(moves.move_one.move) \(moves.move_two.move)"
            pgn_moves += " \(move)"
        }
        let pgnString = """
            [White "\(white)"]
            [Black "\(black)"]
            [WhiteElo "\(whiteElo ?? "N/A")"]
            [BlackElo "\(blackElo ?? "N/A")"]
            [Event "\(event ?? "N/A")"]
            [Site "\(site ?? "N/A")"]
            [Result "\(result)"]
            
            \(pgn_moves)\(self.result)
            """
        return pgnString
    }
}
