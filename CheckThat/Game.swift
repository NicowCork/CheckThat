//
//  Game.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Foundation
import SwiftUI


struct Game: Identifiable {
    let id = UUID()
    let game_date = Date()
    var moves: [PairMove] = []
}

struct PairMove: Identifiable {
    let id = UUID()
    let move_one: Move
    let move_two: Move
}

struct Move: Identifiable {
    let id = UUID()
    let move_date: Date
    let move: String
}

struct MovesData {
    let letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8"]
    let pieces_letters = ["R", "N", "B", "K", "Q"]
    let actions = ["O-O", "x","O-O-O"]
}
