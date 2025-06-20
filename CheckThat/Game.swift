//
//  Game.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Swift
import Foundation

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
