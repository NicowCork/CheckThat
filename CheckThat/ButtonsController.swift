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
    var kingAllowed: Bool = true
    var moveAllowed: Bool = false
    var rockAllowed: Bool = false
    var mateAllowed: Bool = false
    var promoAllowed: Bool = false

    mutating func ControlButtons(forInput input: String) {
        if input == "..." {
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = true
            kingAllowed = true
            moveAllowed = false
            rockAllowed = true
            mateAllowed = false
            promoAllowed = false
        } else if input.last == "#" {
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = false
            kingAllowed = false
            piecesAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.last == "+" {
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.last == "x" {
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.pawn.rawValue) { // a
            takeAllowed = true
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.piece.rawValue) { // N
            takeAllowed = true
            checkAllowed = false
            rankAllowed = true
            fileAllowed = true
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.king.rawValue) { // K
            takeAllowed = true
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.king_file.rawValue) { // Kf
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.king_file_rank.rawValue) { // Kf3
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = false
        } else if input.matches(movesRegexes.king_take.rawValue) { // Kx
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.king_take_file.rawValue) { // Kxf
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.king_take_file_rank.rawValue) { // Kxf3
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = false
        } else if input.matches(movesRegexes.piece_file.rawValue) { // Nc
            takeAllowed = true
            checkAllowed = false
            rankAllowed = true
            fileAllowed = true
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.piece_rank.rawValue) { // N4
            takeAllowed = true
            checkAllowed = false
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.piece_rank_file.rawValue) { // N4f rank en litige
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.piece_file_file.rawValue) { // Ncd file en litige
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.piece_file_file_rank.rawValue) { // Ncd4
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = false
        } else if input.matches(movesRegexes.piece_file_rank.rawValue) { // Nc4
            takeAllowed = true
            checkAllowed = true
            rankAllowed = false
            fileAllowed = true
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = false
        } else if input.matches(movesRegexes.piece_file_rank_file.rawValue) { // Nc4e
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.piece_file_rank_file_rank.rawValue) { // Nc4e5
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = false
        } else if input.matches(movesRegexes.pawn_rank.rawValue) { // e4
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = true
        } else if input.matches(movesRegexes.piece_taking_file.rawValue) { // Nxf
            takeAllowed = false
            checkAllowed = false
            rankAllowed = true
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.pawn_taking_file_rank.rawValue) { // exf4
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = true
        } else if input.matches(movesRegexes.piece_taking_file_rank.rawValue) { // Nxf4
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = false
        } else if input.matches(movesRegexes.all_rocks.rawValue) { // O-O-O O-O
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = false
        } else if input.matches(movesRegexes.piece_rank_file_rank.rawValue) { // F4c4
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = false
        } else if input.matches(movesRegexes.pawn_rank_prom.rawValue) { // c4=
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = true
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.pawn_rank_prom_done.rawValue) { // c8=Q
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = false
        } else if input.matches(movesRegexes.pawn_take_file_rank_prom.rawValue) { // cxd4=
            takeAllowed = false
            checkAllowed = false
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = true
            kingAllowed = false
            moveAllowed = false
            rockAllowed = false
            mateAllowed = false
            promoAllowed = false
        } else if input.matches(movesRegexes.pawn_take_file_rank_prom_done.rawValue) { // cxd4=Q
            takeAllowed = false
            checkAllowed = true
            rankAllowed = false
            fileAllowed = false
            piecesAllowed = false
            kingAllowed = false
            moveAllowed = true
            rockAllowed = false
            mateAllowed = true
            promoAllowed = false
        }
    }
}

enum movesRegexes: String {
    case pawn = "^[a-h]$" // début d'un pion
    case pawn_rank = "^[a-h][1-8]$" // pion mouvement simple
    case pawn_rank_prom = "^[a-h][1-8]=$"
    case pawn_rank_prom_done = "^[a-h][1-8]=[QRBN]$"
    case pawn_take_file_rank_prom = "^[a-h]x[a-h][1-8]=$"
    case pawn_take_file_rank_prom_done = "^[a-h]x[a-h][1-8]=[KGRBN]$"
    case pawn_taking_file_rank = "^[a-h]x[a-h][1-8]$" // pawn capture  complète
    case piece = "^[QRBN]$" // début d'une pièce
    case king = "^K$"
    case king_file = "^[K][a-h]$"
    case king_file_rank = "^K[a-h][1-8]$"
    case king_take = "^Kx$"
    case king_take_file = "^Kx[a-h]$"
    case king_take_file_rank = "^Kx[a-h][1-8]$"
    case piece_file = "^[QRBN][a-h]$" // pièce + colonne
    case piece_file_file = "^[QRBN][a-h][a-h]$" // pièce + colonne + colonne
    case piece_file_file_rank = "^[QRBN][a-h][a-h][1-8]$" // pièce + colonne + colonne
    case piece_file_rank = "^[QRBN][a-h][1-8]$" // pièce + colonne + ligne
    case piece_rank = "^[QRBN][1-8]$" // pion mouvement simple
    case piece_file_rank_file = "^[QRBN][a-h][1-8][a-h]$"
    case piece_rank_file = "^[QRBN][1-8][a-h]$" // pion mouvement simple
    case piece_rank_file_rank = "^[QRBN][1-8][a-h][1-8]$" // pion mouvement simple
    case piece_file_rank_file_rank = "^[QRBN][a-h][1-8][a-h][1-8]$"
    case piece_taking_file = "^([a-h]|[QRBN]|[QRBN][1-8]|[QRBN][a-h]|[QRBN][a-h][1-8])x[a-h]$" // piece capture colonne
    case piece_taking_file_rank = "^([QRBN]|[QRBN][1-8]|[QRBN][a-h]|[QRBN][a-h][1-8])x[a-h][1-8]$" // piece capture complète
    case all_rocks = "^O-O(-O)?$" // rocks
}
