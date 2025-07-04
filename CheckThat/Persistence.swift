//
//  Persistence.swift
//  CheckThat
//
//  Created by Nicolas on 04/07/2025.
//

import Foundation
import SwiftData

@Model
class DataGame: Identifiable {
    var id: String
    var white_name: String
    var black_name: String
    var result: String
    var white_elo: String
    var black_elo: String
    var event: String
    var site: String
    var game: String

    init(white_name: String, black_name: String, result: String, white_elo: String, black_elo: String, event: String, site: String, game: String) {
        self.id = UUID().uuidString
        self.white_name = white_name
        self.black_name = black_name
        self.result = result
        self.white_elo = white_elo
        self.black_elo = black_elo
        self.event = event
        self.site = site
        self.game = game
    }
}
