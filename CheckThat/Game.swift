//
//  Game.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Foundation

struct Game: Identifiable {
    let id = UUID()
    var count_moves : Int = 0
    let game_date = Date()
    var pair_Moves: [PairMove] = []
}

struct PairMove: Identifiable {
    let id = UUID()
    var id_: Int = 0
    let move_one: Move
    let move_two: Move
}

struct Move: Identifiable {
    let id = UUID()
    let move: String
}

struct MovesData {
    let letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8"]
    let pieces_letters = ["R", "N", "B", "Q", "K"]
    let footprints_pieces = ["ROOK", "KNIGHT", "BISHOP", "QUEEN", "KING"]
    let take = ["TAKE"]
    let rocks = ["O-O-O", "O-O"]
    let check = ["CHECK"]
    let mate = ["MATE"]
    let promo = ["PROMO"]
}
