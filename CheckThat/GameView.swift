//
//  GameView.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import SwiftUI
import SwiftData

struct MoveView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var game_controller = GameController()
    @State var white_name = ""
    @State var black_name = ""
    @State var white_elo = ""
    @State var black_elo = ""
    @State var result = ""
    @State var event = ""
    @State var site = ""
    @State var isDrawOffered: Bool = false
    @State var isResetPressed: Bool = false
    @State var isHistoricPressed: Bool = false
    @State var scale: CGFloat = 1.0
    
    enum Field {
        case white_n, black_n, white_e, black_e, event, site
    }
    @FocusState private var focusedField: Field?
    @FocusState var isWhiteNameFieldFocused: Bool
    @FocusState var isBlackNameFieldFocused: Bool
    
    let moves = MovesData()
    
    func addGame() {
        let game = DataGame(white_name: white_name,
                            black_name: black_name,
                            result: game_controller.result,
                            white_elo: white_elo,
                            black_elo: black_elo,
                            event: event,
                            site: site,
                            game: game_controller.gameToBeSaved)
        context.insert(game)
    }
    
    @Query private var dataGames: [DataGame]
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 20) {
                
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
                    
                    Button(action: {
                        isHistoricPressed.toggle()
                    }) {
                        Text("H")
                    }
                    .buttonStyle(actionStyle(color: isHistoricPressed ? Color.blue : Color.gray))
                }  // MARK: Live Score & Historic button
                
                Spacer(minLength: 10)
                
                HStack {
                    Button(action: {
                        isDrawOffered = true
                    }) {
                        Text("DRAW")
                            .font(Font.system(size: 22))
                    }
                    .buttonStyle(actionStyle(color: Color.blue))
                    .blur(radius: game_controller.game.id_ <= 2 ? 2 : 0)
                    .disabled(game_controller.game.id_ <= 2 ? true : false)
                    
                    Spacer()
                    
                    Button(action: {
                        isResetPressed = true
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
                } // MARK: Draw, Reset & DEL
                
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
                }.blur(radius: game_controller.isGameFinished ? 4 : 0 ) // MARK: Pawns/files
                
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
                }.blur(radius: game_controller.isGameFinished ? 4 : 0 ) // MARK: Rank
                
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
                }.blur(radius: game_controller.isGameFinished ? 4 : 0 ) // MARK: Pieces
                
                Divider()
                
                HStack {
                    VStack {
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
                }.blur(radius: game_controller.isGameFinished ? 4 : 0 ) // MARK: Actions
                    .disabled(game_controller.isGameFinished ? true : false)
                
                Divider()
                
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
                }.blur(radius: game_controller.isGameFinished ? 4 : 0 ) // MARK: Validate button
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
                }.scaleEffect(x: 1, y: -1, anchor: .center) // MARK: List
                    .scrollContentBackground(.hidden)
                    .blur(radius: game_controller.isGameFinished ? 4 : 0 )
            }  // MARK: Main window
            .disabled(game_controller.isGameFinished ? true : false)
            .zIndex(1)
            .padding()
            
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn") {
                        
                        ShareLink(item: fileURL) {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .font(Font.system(size: 15))
                        }.buttonStyle(actionStyle(color: Color.purple))
                            .disabled((white_name.isEmpty || black_name.isEmpty) ? true : false)
                            .blur(radius: (white_name.isEmpty || black_name.isEmpty) ? 2 : 0 )
                    }
                    
                    Button(action: {
                        addGame()
                        game_controller.newGame()
                        white_name = ""
                        black_name = ""
                        white_elo = ""
                        black_elo = ""
                        result = ""
                        event = ""
                        site = ""
                    }) {
                        Text("Save")
                            .font(Font.system(size: 15))
                    }.buttonStyle(actionStyle(color: Color.purple))
                        .disabled((white_name.isEmpty || black_name.isEmpty) ? true : false)
                        .blur(radius: (white_name.isEmpty || black_name.isEmpty) ? 2 : 0 )
                    
                    Button(action: {
                        game_controller.newGame()
                        white_name = ""
                        black_name = ""
                        white_elo = ""
                        black_elo = ""
                        result = ""
                        event = ""
                        site = ""
                    }) {
                        Text("NEW GAME")
                            .font(Font.system(size: 15))
                        
                    }.buttonStyle(actionStyle(color: Color.purple))
                }
                
                HStack {
                    Text("White:")
                    TextField("White Player Name", text: $white_name)
                        .focused($focusedField, equals: .white_n)
                        .focused($isWhiteNameFieldFocused)
                }

                .padding(5)
                .background()
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 2)
                )
                HStack {
                    Text("Black:")
                    TextField("Black Player Name", text: $black_name)
                        .focused($focusedField, equals: .black_n)
                        .focused($isBlackNameFieldFocused)
                }
                .padding(5)
                .background()
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 2)
                )
                HStack {
                    Text("Result: \(game_controller.result)")
                }
                .padding(5)
                .background()
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 2)
                )
                HStack {
                    Text("White Elo:")
                    TextField("White Elo (Optional)", text: $white_elo)
                        .focused($focusedField, equals: .white_e)
                        .keyboardType(.numberPad)
                        .onChange(of: white_elo) { newValue in
                            if newValue.count > 4 {
                                white_elo = String(newValue.prefix(4))
                            }
                        }
                }
                .padding(5)
                .background()
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 2)
                )
                HStack {
                    Text("Black Elo:")
                    TextField("Black Elo (Optional)", text: $black_elo)
                        .focused($focusedField, equals: .black_e)
                        .keyboardType(.numberPad)
                        .onChange(of: black_elo) { newValue in
                            if newValue.count > 4 {
                                black_elo = String(newValue.prefix(4))
                            }
                        }
                }
                .padding(5)
                .background()
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 2)
                )
                HStack {
                    Text("Event:")
                    TextField("Event Name (Optional)", text: $event)
                        .focused($focusedField, equals: .event)
                }
                .padding(5)
                .background()
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 2)
                )
                HStack {
                    Text("Site:")
                    TextField("Site Name (Optional)", text: $site)
                        .focused($focusedField, equals: .site)
                }
                .padding(5)
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
                
            } // MARK: Result
            .onSubmit {
                writeTextToFile(text: game_controller.getPGNContent(forWhite: white_name, andBlack: black_name, result: game_controller.result, event: event, site: site, blackElo: black_elo, whiteElo: white_elo), fileName: "Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn")
                if focusedField == .white_n {
                    focusedField = .black_n
                }
                if focusedField == .black_n {
                    focusedField = .white_e
                }
            }
            .submitLabel(.done)
            .autocorrectionDisabled()
            .padding()
            .frame(width: 340, height: 630, alignment: .center)
            .background(Color.mint)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.blue, lineWidth: 3)
            )
            .zIndex(game_controller.isGameFinished ? 2 : 0)
            .opacity(game_controller.isGameFinished ? 2 : 0)
            .offset(y: isWhiteNameFieldFocused ? 40 : 0)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard){
                     Spacer()
                     Button("Done") {
                         writeTextToFile(text: game_controller.getPGNContent(forWhite: white_name, andBlack: black_name, result: game_controller.result, event: event, site: site, blackElo: black_elo, whiteElo: white_elo), fileName: "Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn")
                         if focusedField == .white_n {
                             focusedField = .black_n
                         }
                         if focusedField == .black_n {
                             focusedField = .white_e
                         }
                         if focusedField == .white_e {
                             focusedField = .black_e
                         }
                         if focusedField == .black_e {
                             focusedField = .event
                         }
                         if focusedField == .event {
                             focusedField = .site
                         }
                         if focusedField == .site {
                             UIApplication.shared.dismissKeyboard()
                         }
                      }
                  }
              }
            
            if isResetPressed {
                VStack {
                    Text("Are you sure you want to reset the game?")
                        .font(Font.system(size: 35))
                        .bold()
                        .foregroundStyle(Color.purple)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            isResetPressed = false
                            game_controller.newGame()
                        }) {
                            Text("Yes")
                                .font(Font.system(size: 35))
                        }
                        
                        Button(action: {
                            isResetPressed = false
                        }) {
                            Text("No!")
                                .font(Font.system(size: 35))
                        }
                    }
                }
                .padding()
                .buttonStyle(actionStyle(color: Color.purple))
                .frame(width: 340, height: 230)
                .background(Color.mint)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 3)
                )
                .zIndex(isResetPressed ? 3 : -1)
            } // MARK: Reset
            
            if isDrawOffered {
                
                VStack {
                    Text("Are you sure you want to draw the game?")
                        .font(Font.system(size: 35))
                        .bold()
                        .foregroundStyle(Color.purple)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            game_controller.result = "1/2-1/2"
                            game_controller.isGameFinished = true
                            isDrawOffered = false
                        }) {
                            Text("Yes")
                                .font(Font.system(size: 35))
                        }
                        
                        Button(action: {
                            isDrawOffered = false
                        }) {
                            Text("No!")
                                .font(Font.system(size: 35))
                        }
                    }
                }
                .padding()
                .buttonStyle(actionStyle(color: Color.purple))
                .frame(width: 340, height: 230)
                .background(Color.mint)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 3)
                )
                .frame(width: 340, height: 330)
                .zIndex(isDrawOffered ? 3 : -1)
            } // MARK: Draw
            
            if isHistoricPressed {
                VStack {
                    List {
                        ForEach (dataGames) { game in
                            HStack {
                                Text("\(game.white_name)")
                                Text("\(game.black_name)")
                                Text("\(game.result)")
                            }
                        }
                    }
                }
                .padding()
                .buttonStyle(actionStyle(color: Color.purple))
                .frame(width: 340, height: 630)
                .background(Color.mint)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 3)
                )
                .frame(width: 340, height: 330)
                .zIndex(isHistoricPressed ? 3 : -1)
            } // MARK: Historic
        }
    }
}

#Preview {
    MoveView()
}
