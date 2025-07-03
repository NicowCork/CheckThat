//
//  GameView.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import SwiftUI

struct MoveView: View {
    @StateObject private var game_controller = GameController()
    @State var white_name = ""
    @State var black_name = ""
    @State var white_elo = ""
    @State var black_elo = ""
    @State var result = ""
    @State var event = ""
    @State var site = ""
    
    let moves = MovesData()
    
    var body: some View {
        
        ZStack {
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
                    .blur(radius: game_controller.isGameFinished ? 4 : 0 )
                    Spacer(minLength: 30)
                }
                
                Spacer(minLength: 10)
                
                HStack {
                    
                    Button(action: {
                        //warning message x2
                        game_controller.result = "1/2-1/2"
                        game_controller.isGameFinished = true
                    }) {
                        Text("DRAW")
                         .font(Font.system(size: 22))
                    }
                    .buttonStyle(actionStyle(color: Color.blue))
                    .blur(radius: game_controller.game.id_ <= 2 ? 2 : 0)
                    .disabled(game_controller.game.id_ <= 2 ? true : false)
                    
                    Spacer()
                    
                    Button(action: {
                        // warning message
                        game_controller.newGame()
                    }) {
                        Text("RESET")
                            .font(Font.system(size: 22))

                    }.buttonStyle(actionStyle(color: Color.mint))
                    .blur(radius: game_controller.isGameFinished ? 4 : 0)
    
          
                    Button (action: {
                        if game_controller.actual_move == "O-O" || game_controller.actual_move == "O-O+" || game_controller.actual_move == "O-O-O" || game_controller.actual_move == "O-O-O+" {
                            game_controller.actual_move = "..."
                        } else {
                            game_controller.remove_last()
                        }
                    }) {
                        Text("DEL")
                            .font(Font.system(size: 22))
                    }.buttonStyle(actionStyle(color: Color.mint))
                    .blur(radius: game_controller.isGameFinished ? 4 : 0 )
                    .disabled(game_controller.isGameFinished ? true : false)
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
                }.blur(radius: game_controller.isGameFinished ? 4 : 0 )
                
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
                }.blur(radius: game_controller.isGameFinished ? 4 : 0 )
       
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
                }.blur(radius: game_controller.isGameFinished ? 4 : 0 )
                Divider()
                // Grille des actions
                HStack {
                    VStack { // check & mate
                        ForEach(moves.check, id: \.self) { thatchar in
                            Button(action: {
                                game_controller.add_character("+")
                            }) {
                                Text(thatchar)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(actionStyle(color: (game_controller.buttonsController.checkAllowed && game_controller.game.id_ >= 1) ? Color.blue : Color.gray))
                            .disabled((game_controller.buttonsController.checkAllowed && game_controller.game.id_ >= 1) ? false : true)
                        }
                        ForEach(moves.mate, id: \.self) { thatchar in
                            Button(action: {
                                game_controller.add_character("#")
                            }) {
                                Text(thatchar)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(actionStyle(color: (game_controller.buttonsController.mateAllowed && game_controller.game.id_ >= 1) ? Color.blue : Color.gray))
                            .disabled((game_controller.buttonsController.mateAllowed && game_controller.game.id_ >= 1) ? false : true)
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
                        .buttonStyle(takeStyle(color: game_controller.buttonsController.takeAllowed  ? Color.blue : Color.gray))
                        .disabled(game_controller.buttonsController.takeAllowed ? false : true)
                        
                    }
                }.blur(radius: game_controller.isGameFinished ? 4 : 0 )
                .disabled(game_controller.isGameFinished ? true : false)
                
                Divider()
                // Bouton valider
                Button(action: {
                    game_controller.isPairComplete ? game_controller.save_move(move: Move(move: game_controller.actual_move)) : game_controller.save_pair(withMoveSaved: game_controller.coup_saved, andMove: Move(move: game_controller.actual_move))
                }) {
                    Text(game_controller.isPairComplete ? "Valider le coup" : "Valider la paire")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(game_controller.isPairComplete ? Color.blue : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }.blur(radius: game_controller.isGameFinished ? 4 : 0 )
                .disabled(game_controller.buttonsController.moveAllowed ? false : true)
                .blur(radius: game_controller.buttonsController.moveAllowed ? 0 : 4)
                .padding(.top)
                
                Spacer()
                
                List {
                    ForEach(game_controller.game.pair_Moves) { pair_move in
                        HStack {
                            Text("\(pair_move.id_). \(pair_move.move_one.move) : \(pair_move.move_two.move)")
                                .scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip list items here
                        }
                    }
                }.scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip the list itself here
                .scrollContentBackground(.hidden)
                .blur(radius: game_controller.isGameFinished ? 4 : 0 )
            }
            .zIndex(1)
            .padding()
            
            VStack(alignment: .center, spacing: 20) {
                HStack {

                    if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn") {
                        
                        ShareLink(item: fileURL) {
                            Label("Share / Save", systemImage: "square.and.arrow.up")
                                .font(Font.system(size: 15))
                        }.buttonStyle(actionStyle(color: Color.purple))
                            .disabled((white_name.isEmpty || black_name.isEmpty) ? true : false)
                            .blur(radius: (white_name.isEmpty || black_name.isEmpty) ? 2 : 0 )
                    }
                    Button(action: {
                        // warning message
                        game_controller.newGame()
                        white_name = ""
                        black_name = ""
                        result = ""
                        event = ""

                    }) {
                        Text("NEW GAME")
                            .font(Font.system(size: 15))

                    }.buttonStyle(actionStyle(color: Color.purple))
                }
 
                HStack {
                    Text("White:")
                    TextField("White Player Name", text: $white_name)
                }
                .background()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                    )
                HStack {
                    Text("Black:")
                    TextField("Black Player Name", text: $black_name)
                }
                .background()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                    )
                HStack {
                    Text("Result: \(game_controller.result)")
                }
                .background()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                    )
                HStack {
                    Text("White Elo:")
                    TextField("White Elo (Optional)", text: $white_elo)
                }
                .background()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                    )
                HStack {
                    Text("Black Elo:")
                    TextField("Black Elo (Optional)", text: $black_elo)
                }
                .background()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                    )
                HStack {
                    Text("Event:")
                    TextField("Event Name (Optional)", text: $event)
                }
                .background()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                    )
                HStack {
                    Text("Site:")
                    TextField("Site Name (Optional)", text: $site)
                }
                .background()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                    )
                  
                List {
                    ForEach(game_controller.game.pair_Moves) { pair_move in
                        HStack {
                            Text("\(pair_move.id_). \(pair_move.move_one.move) : \(pair_move.move_two.move)")
                                .scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip list items here
                        }
                    }
                }.scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip the list itself here
                .scrollContentBackground(.hidden)

            }
            .onSubmit {
                writeTextToFile(text: game_controller.getPGNContent(forWhite: white_name, andBlack: black_name, result: result, event: event, site: site, blackElo: black_elo, whiteElo: white_elo), fileName: "Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn")
            }
            .autocorrectionDisabled()
            .padding()
            .frame(width: 340, height: 530, alignment: .center)
            .background(Color.mint)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 3)
                )
            .zIndex(game_controller.isGameFinished ? 2 : 0)
            .opacity(game_controller.isGameFinished ? 2 : 0)
        }
    }
}

#Preview {
    MoveView()
}
