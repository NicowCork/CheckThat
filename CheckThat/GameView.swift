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
            HStack {
                HStack(spacing: 15) {
                    Text("1. ")
                        .font(Font.system(size: 20))
                        .background(Color.mint)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(y: 10)
                    Text(game_controller.isPairComplete ? game_controller.actual_move : game_controller.coup_saved.move)
                        .font(Font.system(size: 33))
                        .background(Color.mint)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
        
                    Text("2. ")
                        .font(Font.system(size: 20))
                        .background(Color.mint)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(y: 10)
                    Text(game_controller.isPairComplete ? "..." : game_controller.actual_move)
                        .font(Font.system(size: 33))
                        .background(Color.mint)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .background(Color.mint)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                
                Spacer(minLength: 30)
            }
            
            HStack {
                Spacer()
                Button (action: {
                    if game_controller.actual_move == "O-O" || game_controller.actual_move == "O-O+" || game_controller.actual_move == "O-O-O" || game_controller.actual_move == "O-O-O+" {
                        game_controller.actual_move = "..."
                    } else {
                        game_controller.remove_last()
                    }
                }) {
                    Text("DEL")
                        .font(Font.system(size: 22))
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
                    .buttonStyle(thatStyle(color: game_controller.buttonsController.fileAllowed ? Color.blue : Color.gray))
                    .disabled(game_controller.buttonsController.fileAllowed ? false : true)
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
                    .buttonStyle(thatStyle(color: game_controller.buttonsController.rankAllowed ? Color.blue : Color.gray))
                    .disabled(game_controller.buttonsController.rankAllowed ? false : true)
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
                    .buttonStyle(thatStyle(color: game_controller.buttonsController.piecesAllowed ? Color.blue : Color.gray))
                    .disabled(game_controller.buttonsController.piecesAllowed ? false : true)
                }
            }
            Divider()
            // Grille des actions
            HStack {
                VStack {
                    ForEach(moves.check, id: \.self) { thatchar in
                        Button(action: {
                            game_controller.add_character("+")
                        }) {
                            Text(thatchar)
                                .cornerRadius(8)
                        }
                        .buttonStyle(actionStyle(color: (game_controller.buttonsController.checkAllowed && game_controller.game.id_ > 2) ? Color.blue : Color.gray))
                        .disabled((game_controller.buttonsController.checkAllowed && game_controller.game.id_ > 2) ? false : true)
                    }
                    ForEach(moves.mate, id: \.self) { thatchar in
                        Button(action: {
                            game_controller.add_character("#")
                        }) {
                            Text(thatchar)
                                .cornerRadius(8)
                        }
                        .buttonStyle(actionStyle(color: (game_controller.buttonsController.mateAllowed && game_controller.game.id_ > 1) ? Color.blue : Color.gray))
                        .disabled((game_controller.buttonsController.mateAllowed && game_controller.game.id_ > 1) ? false : true)
                    }
                }
                VStack {
                    ForEach(moves.rocks, id: \.self) { thatchar in
                        Button(action: {
                            game_controller.add_character(thatchar)
                        }) {
                            Text(thatchar)
                                .cornerRadius(8)
                        }
                        .buttonStyle(actionStyle(color: (game_controller.game.id_ > 2 && game_controller.buttonsController.rockAllowed) ? Color.blue : Color.gray))
                        .disabled((game_controller.game.id_ > 2 && game_controller.buttonsController.rockAllowed) ? false : true)
                    }
                }
                ForEach(moves.take, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character("x")
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(takeStyle(color: (game_controller.buttonsController.takeAllowed && game_controller.game.id_ > 1)  ? Color.blue : Color.gray))
                    .disabled((game_controller.buttonsController.takeAllowed && game_controller.game.id_ > 1) ? false : true)
                    
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
            .disabled(game_controller.buttonsController.moveAllowed ? false : true)
            .blur(radius: game_controller.buttonsController.moveAllowed ? 0 : 4)
            .padding(.top)
            
            Spacer()
            
            List {
                ForEach(game_controller.game.moves) { move in
                    HStack {
                        Text("\(move.id_). \(move.move_one.move) : \(move.move_two.move)")
                            .scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip list items here
                    }
                }
            }.scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip the list itself here
                .scrollContentBackground(.hidden)
        }
        .padding()
    }
}

#Preview {
    MoveView()
}
