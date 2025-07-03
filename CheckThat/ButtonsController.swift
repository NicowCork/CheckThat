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
    var mateAllowed: Bool = false

    mutating func ControlButtons(forInput input: String) {
        if input == "..." {
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = true
            moveAllowed = false
            rockAllowed = true
            mateAllowed = false
        } else if input.last == "#" {
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = false
        } else if input.last == "+" {
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = false
        } else if input.matches(movesRegexes.pawn.rawValue) { // a
            takeAllowed = true
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
        } else if input.matches(movesRegexes.piece.rawValue) { // N
            takeAllowed = true
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
        } else if input.matches(movesRegexes.piece_file.rawValue) { // Nc file en litige
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = true
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
        } else if input.matches(movesRegexes.piece_rank.rawValue) { // N4
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
        } else if input.matches(movesRegexes.piece_rank_file.rawValue) { // N4f rank en litige
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
        } else if input.matches(movesRegexes.piece_file_file.rawValue) { // Ncd
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
        } else if input.matches(movesRegexes.piece_file_file_rank.rawValue) { // Ncd4
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
        } else if input.matches(movesRegexes.piece_file_rank.rawValue) { // Nc4
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
        } else if input.matches(movesRegexes.piece_file_rank_file.rawValue) { // Nc4e
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
        } else if input.matches(movesRegexes.piece_file_rank_file_rank.rawValue) { // Nc4e5
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
        } else if input.matches(movesRegexes.pawn_rank.rawValue) { // e4
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
        } else if input.matches(movesRegexes.pawn_taking.rawValue) || input.matches(movesRegexes.piece_taking.rawValue) { // ex & Nx
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
        } else if input.matches(movesRegexes.pawn_taking_file.rawValue) || input.matches(movesRegexes.piece_taking_file.rawValue) { // exf & Nxf
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
        } else if input.matches(movesRegexes.pawn_taking_file_rank.rawValue) || input.matches(movesRegexes.piece_taking_file_rank.rawValue) { // exf4 & Nxf4
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
        } else if input.matches(movesRegexes.all_rocks.rawValue) { // O-O-O
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
        }
    }
}

enum movesRegexes: String {
    case pawn = "^[a-h]$" // début d'un pion
    case piece = "^[KQRBN]$" // début d'une pièce
    case piece_file = "^[KQRBN][a-h]$" // pièce + colonne
    case piece_file_file = "^[KQRBN][a-h][a-h]$" // pièce + colonne + colonne
    case piece_file_file_rank = "^[KQRBN][a-h][a-h][1-8]$" // pièce + colonne + colonne
    case pawn_rank = #"^[a-h][1-8]$"# // pion mouvement simple
    case piece_file_rank = "^[KQRBN][a-h][1-8]$" // pièce + colonne + ligne
    case piece_rank = #"^[KQRBN][1-8]$"# // pion mouvement simple
    case piece_file_rank_file = "^[KQRBN][a-h][1-8][a-h]$"
    case piece_rank_file = #"^[KQRBN][1-8][a-h]$"# // pion mouvement simple
    case piece_file_rank_file_rank =  #"^[KQRBN][a-h][1-8][a-h][1-8]$"#
    case pawn_taking = #"^[a-h]x$"# // pion qui va capturer
    case piece_taking = "^[KQRBN]x$" // pièce qui va capturer
    case pawn_taking_file = #"^[a-h]x[a-h]$"# // pion capture colonne
    case piece_taking_file = "^[KQRBN]x[a-h]$" // piece capture colonne
    case piece_taking_file_rank = "^[KQRBN]x[a-h][1-8]$" // piece capture complète
    case pawn_taking_file_rank = "^[a-h]x[a-h][1-8]$" // pawn capture  complète
    case all_rocks = "^O-O(-O)?$" // rocks
}
