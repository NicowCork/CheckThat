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
            
            // Coup actuellement joué
            Text(game_controller.actual_move)
                .font(Font.system(size: 50))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.3))
                )
            
            // Grille des pièces majeurs
            HStack {
                ForEach(moves.pieces_letters, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .padding(10)
                    }.buttonStyle(letterStyle())
                }
            }

            // Grille des colonnes / pions
            HStack {
                ForEach(moves.letters, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(letterStyle())
                }
            }
            
            // Grilles des nombres / rank
            HStack {
                ForEach(moves.numbers, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character(thatchar)
                    }) {
                        Text(thatchar)
                            .font(Font.system(size: 15))
                            .cornerRadius(8)
                    }.buttonStyle(numberStyle())
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
                game_controller.save_move(move: Move(move_date: Date(), move: game_controller.actual_move))
            }) {
                Text("Valider le coup")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)

            // Dernier coup
            Text("Dernier coup : \(game_controller.game.moves.last?.move ?? "N/A")")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top)
            List {
                ForEach(game_controller.game.moves) { move in
                    Text(move.move)
                }
            }
        }
        .padding()
    }
}

#Preview {
    MoveView()
}
