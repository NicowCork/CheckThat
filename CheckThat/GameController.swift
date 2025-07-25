//
//  GameController.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Foundation
import AVFoundation

class GameController: ObservableObject {
    init(actual_move: String = "...", game: Game = Game()) {
        self.actual_move = actual_move
        self.game = game
    }
    
    @Published var game: Game
    @Published var buttonsController: ButtonsController = ButtonsController()
    
    @Published var isWhitePlaying = true
    @Published var isGameFinished = false
    @Published var hasWhiteCastle = false
    @Published var hasBlackCastle = false
    
    @Published var actual_move: String {
        willSet {
            buttonsController.ControlButtons(forInput: newValue)
        }
    }
    @Published var white_saved_move = "..."
    @Published var result = ""
    
    func add(_ character: String) { actual_move == "..." ? actual_move = character : actual_move.append(character) }
    func remove() {
        if actual_move.count == 1 || actual_move.matches("O$") { actual_move = "..." } else { actual_move.removeLast() }
    }
    
    func checkForCastle() {
        if isWhitePlaying && (actual_move == "O-O" || actual_move == "O-O-O") { hasWhiteCastle = true }
        if !isWhitePlaying && (actual_move == "O-O" || actual_move == "O-O-O") { hasBlackCastle = true }
    }
    func checkForMate() {
        if isWhitePlaying && (actual_move.last == "#") { result = "1-0"; isGameFinished = true }
        if !isWhitePlaying && (actual_move.last == "#") { result = "0-1"; isGameFinished = true }
    }
    
    func save() {
        if isWhitePlaying { game.moves.append(Moves(number: game.count_moves, move_white: actual_move)); white_saved_move = actual_move }
        else { game.moves.removeLast(); game.moves.append(Moves(number: game.count_moves, move_white: white_saved_move, move_black: actual_move)) }
        
        checkForCastle()
        checkForMate()
        actual_move = "..."
        if !isWhitePlaying { game.count_moves += 1 }
        isWhitePlaying.toggle()
    }
    func newGame() {
        actual_move = "..."
        result = ""
        self.game = Game()
        self.isWhitePlaying = true
        self.isGameFinished = false
        self.white_saved_move = "..."
        self.hasWhiteCastle = false
        self.hasBlackCastle = false
    }

    func getPGNContent(forWhite white: String, andBlack black : String, result: String, event: String?, site: String?, blackElo: String?, whiteElo: String?, date: Date) -> String {
        var pgn_moves = ""
        for moves in game.moves {
            let move = "\(moves.number).\(moves.move_white) \(moves.move_black)"
            pgn_moves += "\(move) "
        }
        if result == "1-0" { pgn_moves.removeLast() }
        
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
        return pgnString
    }
}
