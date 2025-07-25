//
//  Game.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Foundation

struct Game: Identifiable {
    let id = UUID()
    var count_moves : Int = 1
    let game_date = Date()
    var moves: [Moves] = []
}

struct Moves: Identifiable {
    let id = UUID()
    var number = 0
    var move_white = ""
    var move_black = ""
}

struct MovesData {
    let letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8"]
    let pieces_letters = ["R", "N", "B", "Q"]
    let king = ["K"]
    let footprints_pieces = ["ROOK", "KNIGHT", "BISHOP", "QUEEN", "KING"]
    let footprint_small_rock = ["SHORT CASTLE"]
    let footprint_big_rock = ["LONG CASTLE"]
    let footprint_promo = ["PROMOTION"]
    let take = ["TAKE"]
    let small_rock = ["O-O"]
    let big_rock = ["O-O-O"]
    let check = ["CHECK"]
    let mate = ["MATE"]
    let promo = ["="]
}
