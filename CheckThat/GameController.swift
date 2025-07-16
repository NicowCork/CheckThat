//
//  GameController.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Foundation
import AVFoundation

class GameController: ObservableObject {
    init(actual_move: String = "...", game: Game = Game(), isWhitePlaying: Bool = true) {
        self.actual_move = actual_move
        self.game = game
        self.isWhitePlaying = isWhitePlaying
    }
    
    @Published var actual_move: String {
        willSet {
            buttonsController.ControlButtons(forInput: newValue)
        }
    }
    @Published var game: Game
    @Published var isWhitePlaying: Bool
    @Published var isGameFinished: Bool = false
    @Published var hasWhiteCastle: Bool = false
    @Published var hasBlackCastle: Bool = false
    @Published var white_saved_move: Move = Move(move: "...")
    @Published var buttonsController: ButtonsController = ButtonsController()
    @Published var result: String = ""
    
    var gameToBeSaved: String = ""
    
    func add_character(_ character: String) {
        if actual_move.last == "=" && character == "K" {
            playSound(sound: "Pouet", type: ".mp3")
        } else if actual_move == "..." {
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
    func save_both(withWhiteMove: Move, andBlackMove move: Move) {
        let pairId: Int = game.count_moves + 1
        game.pair_Moves.append(PairMove(id_: pairId, move_white: white_saved_move, move_black: move))
        
        if game.pair_Moves.last?.move_white.move.last == "#" {
            result = "1-0"
        } else if game.pair_Moves.last?.move_black.move.last == "#" {
            result = "0-1"
        }
        
        if actual_move.last == "#" {
            isGameFinished = true
        } else {
            if actual_move == "O-O" || actual_move == "O-O-O" {
                hasBlackCastle = true
            }
            game.count_moves += 1
            actual_move = "..."
            isWhitePlaying = true
        }
    }
    func save_white(move: Move) {
        if actual_move.last == "#" {
            white_saved_move = move
            save_both(withWhiteMove: move, andBlackMove: Move(move: "")) //end
        } else {
            if actual_move == "O-O" || actual_move == "O-O-O" {
                hasWhiteCastle = true
            }
            white_saved_move = move
            actual_move = "..."
            isWhitePlaying = false
        }
    }
    func newGame() {
        actual_move = "..."
        result = ""
        self.game = Game()
        self.isWhitePlaying = true
        self.isGameFinished = false
        self.white_saved_move = Move(move: "...")
        self.hasWhiteCastle = false
        self.hasBlackCastle = false
    }
    func getPGNContent(forWhite white: String, andBlack black : String, result: String, event: String?, site: String?, blackElo: String?, whiteElo: String?, date: Date) -> String {
        var pgn_moves = ""
        for moves in game.pair_Moves {
            let move = "\(moves.id_).\(moves.move_white.move) \(moves.move_black.move)"
            pgn_moves += "\(move) "
        }
        
        let pgnString = """
            [White "\(white)"]
            [Black "\(black)"]
            [WhiteElo "\(whiteElo ?? "N/A")"]
            [BlackElo "\(blackElo ?? "N/A")"]
            [Event "\(event ?? "N/A")"]
            [Site "\(site ?? "N/A")"]
            [Date "\(date.formatted())"]
            [Result "\(result)"]
            
            \(pgn_moves)\(self.result)
            """
        gameToBeSaved = pgnString
        return pgnString
    }
}
