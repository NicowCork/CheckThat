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
                HStack {
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: 25, height: 25)
                        .overlay {
                            RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.black)
                        }
                        
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: 25, height: 25)
                        .overlay {
                            RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.white)
                        }
                }
                
                Spacer()
                
                HStack {
                    Text("Move:")
                        .font(Font.system(size: 30))
                        .background(Color.mint)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Text(game_controller.actual_move)
                        .font(Font.system(size: 30))
                        .background(Color.mint)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                }.overlay {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .strokeBorder(Color.mint, lineWidth: 1)
                }

                    
                
                Spacer()
                
                Button (action: {
                    game_controller.remove_last()
                }) {
                    Text("DEL")
                        .font(Font.system(size: 30))
                        .foregroundStyle(Color.orange)
                }.buttonStyle(actionStyle(color: Color.mint))
                
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
                    .buttonStyle(thatStyle(color: game_controller.move_validation == .only_file_and_pieces_allowed || game_controller.move_validation == .rank_and_file_allowed || game_controller.move_validation == .only_file_and_pieces_allowed ? Color.blue : Color.gray))
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
                    }
                    .buttonStyle(thatStyle(color: game_controller.move_validation == .rank_and_file_allowed || game_controller.move_validation == .only_rank_allowed ? Color.blue : Color.gray))
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
                    }
                    .buttonStyle(thatStyle(color: game_controller.move_validation == .only_file_and_pieces_allowed ? Color.blue : Color.gray))
                }
            }
            Divider()
            // Grille des actions
            HStack {
                ForEach(moves.take, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character("x")
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(actionStyle(color: Color.blue))
                    
                }
                
                VStack {
                    ForEach(moves.rocks, id: \.self) { thatchar in
                        Button(action: {
                            game_controller.add_character(thatchar)
                        }) {
                            Text(thatchar)
                                .cornerRadius(8)
                        }
                        .buttonStyle(actionStyle(color: Color.blue))
                    }
                }
                
                ForEach(moves.check, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character("+")
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(actionStyle(color: Color.blue))
                }
            }
            Divider()
            // Bouton valider
            Button(action: {
                if game_controller.actual_move == "..." {
                    print("")
                }
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
                            .scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip list items here
                    }
                }
            }.scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip the list itself here
        }
        .padding()
    }
}

#Preview {
    MoveView()
}
