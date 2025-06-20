//
//  GameView.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import SwiftUI

struct MoveView: View {
    @StateObject private var game_controller = GameController(actual_move: "", moves: [])
    
    let pieces_letters = ["R", "N", "B", "K", "Q"]
    let letters = ["a", "b", "c", "d", "e", "f", "g", "h"] // files
    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8"] // rank
    let actions = ["x", "O-O", "O-O-O"]
            
    var body: some View {
        VStack(spacing: 20) {
            
            // Coup actuellement joué
            
            Text(game_controller.actual_move)
            
            // Grille des grosse pièces
            HStack {
                ForEach(pieces_letters, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .padding()
                            .cornerRadius(8)
                    }
                }
            }

            // Grille des colonnes / files
            HStack {
                ForEach(letters, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .padding()
                            .cornerRadius(8)
                    }
                }
            }
            
            // Grilles des nombres / rank
            HStack {
                ForEach(numbers, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .padding()
                            .cornerRadius(8)
                    }
                }
            }
            
            // Grille des actions
            HStack {
                ForEach(actions, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .padding()
                            .cornerRadius(8)
                    }
                }
            }

            // Bouton valider
            Button(action: {
                game_controller.save_move(move: Move(move_date: Date(), move: game_controller.actual_move))
            }) {
                Text("✅ Enregistrer le coup")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)

            // Dernier coup
            Text("Dernier coup : \(game_controller.game.moves.last?.move ?? "N/A")")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top)
            
            ForEach(game_controller.game.moves) { move in
                Text(move.move)
            }
                
        }
        .padding()
    }
}

