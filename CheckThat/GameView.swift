//
//  GameView.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import SwiftUI

struct MoveView: View {
    @StateObject private var game_controller = GameController()
    let moves = MovesData()
                
    var body: some View {
        VStack(spacing: 20) {
            
            // Coup actuellement joué & Delete button
            HStack(spacing: 15) {
                Text(game_controller.actual_move)
                    .font(Font.system(size: 50))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.3))
                    ).clipShape(Capsule())
                Button (action: {
                    game_controller.delete_last()
                }) {
                    Text("DELETE")
                        .font(Font.system(size: 30))
                        .background(Color.red)
                }.clipShape(Capsule())

            }
        
            // Grille des colonnes / pions
            HStack(spacing: 1) {
                ForEach(moves.letters, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(thatStyle())
                }
            }
                        
            // Grilles des nombres / rank
            HStack(spacing: 1) {
                ForEach(moves.numbers, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }.buttonStyle(thatStyle())
                }
            }
            
            // Grille des pièces majeurs
            HStack {
                ForEach(moves.pieces_letters, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }.buttonStyle(thatStyle())
                }
            }
            
            // Grille des actions
            HStack {
                ForEach(moves.actions, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .font(.largeTitle)
                            .cornerRadius(8)
                    }.buttonStyle(actionStyle())
                }
            }

            // Bouton valider
            Button(action: {
                game_controller.isPairComplete ? game_controller.save_move(move: Move(move_date: Date(), move: game_controller.actual_move)) : game_controller.save_pair(withMoveSaved: game_controller.coup_saved, andMove: Move(move_date: Date(), move: game_controller.actual_move))
            }) {
                Text(game_controller.isPairComplete ? "Valider le coup" : "Valider la paire")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(game_controller.isPairComplete ? Color.blue : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)

            // Dernier coup
            Text("Dernier coup : \(game_controller.game.moves.last?.move_one.move ?? "N/A") : \((game_controller.game.moves.last?.move_two.move) ?? "N/A")")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top)
            List {
                ForEach(game_controller.game.moves) { move in
                    HStack {
                        Text("\(move.move_one.move) : \(move.move_two.move)")
                        
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    MoveView()
}
