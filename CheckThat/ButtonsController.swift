//
//  ButtonsController.swift
//  CheckThat
//
//  Created by Nicolas on 21/06/2025.
//

import Foundation

struct ButtonsController {
    var takeAllowed: Bool = false
    var checkAllowed: Bool = false
    var rankAllowed: Bool = false
    var fileAllowed: Bool = true
    var piecesAllowed: Bool = true
    var moveAllowed: Bool = false
    var rockAllowed: Bool = false

    mutating func ControlButtons(forInput input: String) {
        if input == "..." {
            print("...")
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = true
            moveAllowed = false
            rockAllowed = true
        } else if input.matches(movesRegexes.pawn.rawValue) || input.matches(movesRegexes.piece_file.rawValue) { // a & Nc
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
        } else if input.matches(movesRegexes.piece.rawValue) { // N
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
        } else if input.matches(movesRegexes.pawn_rank.rawValue) || input.matches(movesRegexes.piece_file_rank.rawValue) { // e4 & Nc3
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
        } else if input.matches(movesRegexes.pawn_taking.rawValue) || input.matches(movesRegexes.piece_taking.rawValue) { // ex & Nx
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
        } else if input.matches(movesRegexes.pawn_taking_file.rawValue) || input.matches(movesRegexes.piece_taking_file.rawValue) { // exf & Nxf
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
        } else if input.matches(movesRegexes.pawn_taking_file_rank.rawValue) || input.matches(movesRegexes.piece_taking_file_rank.rawValue) { // exf4 & Nxf4
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
        } else if input.matches(movesRegexes.all_rocks.rawValue) { // O-O-O
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
        } else if input.matches(movesRegexes.all_checked.rawValue) || input.matches(movesRegexes.rock_checked.rawValue) { // +
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
        }
    }
}

enum movesRegexes: String {
    case pawn = "^[a-h]$" // début d'un pion
    case piece = "^[KQRBN]$" // début d'une pièce
    case piece_file = "^[KQRBN][a-h]$" // pièce + colonne
    case pawn_rank = #"^[a-h][1-8]$"# // pion mouvement simple
    case piece_file_rank = "^[KQRBN][a-h][1-8]$" // pièce + colonne + ligne
    case pawn_taking = #"^[a-h]x$"# // pion qui va capturer
    case piece_taking = "^[KQRBN]x$" // pièce qui va capturer
    case pawn_taking_file = #"^[a-h]x[a-h]$"# // pion capture colonne
    case piece_taking_file = "^[KQRBN]x[a-h]$" // piece capture colonne
    case piece_taking_file_rank = "^[KQRBN]x[a-h][1-8]$" // piece capture complète
    case pawn_taking_file_rank = "^[a-h]x[a-h][1-8]$" // pawn capture  complète
    case all_rocks = "^O-O(-O)?\\$" // rocks
    case all_checked = "^(([KQRBN][a-h][1-8]|[a-h][1-8])|([KQRBN]x[a-h][1-8])|([a-h]x[a-h][1-8]))+$" // pieces checked
    case rock_checked = "^O-O(-O)?\\+?$" // rocks and checks
}
