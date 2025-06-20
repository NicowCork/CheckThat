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
    var moves: [Move] = []
}

struct Move: Identifiable {
    let id = UUID()
    let move_date: Date
    let move: String
}

struct MovesData {
    let pieces_letters = ["R", "N", "B", "K", "Q"]
    let letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8"]
    let actions = ["O-O", "x","O-O-O"]
}
