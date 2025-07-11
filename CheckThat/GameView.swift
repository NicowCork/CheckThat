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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Query private var dataGames: [DataGame]
    
    @StateObject private var game_controller = GameController()
    @State private var white_name = ""
    @State private var black_name = ""
    @State private var white_elo = ""
    @State private var black_elo = ""
    @State private var result = ""
    @State private var event = ""
    @State private var site = ""
    @State private var isMenuPressed: Bool = false
    @State private var isDrawOffered: Bool = false
    @State private var isResetPressed: Bool = false
    @State private var isHistoricPressed: Bool = false
    @State private var isSavePressed: Bool = false
    @State private var currentIndex: Int = 0
    
    @FocusState private var focusedField: Field?
    @FocusState private var isWhiteNameFieldFocused: Bool
    @FocusState private var isBlackNameFieldFocused: Bool
    
    private let moves = MovesData()
    private enum Field { case white_n, black_n, white_e, black_e, event, site }
    
    private func resetResult() {
        white_name = ""
        black_name = ""
        white_elo = ""
        black_elo = ""
        result = ""
        event = ""
        site = ""
    }
    private func addGame() {
        let game = DataGame(white_name: white_name,
                            black_name: black_name,
                            result: game_controller.result,
                            white_elo: white_elo,
                            black_elo: black_elo,
                            event: event,
                            site: site,
                            date: game_controller.game.game_date,
                            game: game_controller.gameToBeSaved)
        context.insert(game)
    }
    
    private var menu : some View {
        HStack {
            if isHistoricPressed {
                Button(action: {
                    isHistoricPressed.toggle()
                }) {
                    Text("HIDE HISTORIC")
                }
                .padding(5)
                .font(.system(size: 28, weight: .bold))
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Spacer()
            Button(action: {
                isMenuPressed.toggle()
            }) {
                Text("\(isMenuPressed ? "LIVE GAME" : "MENU")")
            }
            .padding(5)
            .font(.system(size: 28, weight: .bold))
            .background(isMenuPressed ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(isHistoricPressed ? true : false)
            .opacity(isHistoricPressed ? 0 : 1)
        }
    }
    private var score : some View {
        HStack {
            HStack  {
                Text("\(game_controller.game.count_moves == 0 ? "1" : "\(game_controller.game.count_moves + 1)").")
                    .font(Font.system(size: 55))
                    .background(Color.mint)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 70)
                
                VStack(spacing: 15) {
                    HStack() {
                        Text(game_controller.isPairComplete ? game_controller.actual_move : game_controller.coup_saved.move)
                            .font(Font.system(size: 35))
                            .background(Color.mint)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Spacer()
                        Text("⚪️")
                            .font(Font.system(size: 35))
                    }
                    .frame(width: 200)
                    .background(Color.mint)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    HStack {
                        Text(game_controller.isPairComplete ? "..." : game_controller.actual_move)
                            .font(Font.system(size: 35))
                            .background(Color.mint)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        Spacer()
                        Text("⚫️")
                            .font(Font.system(size: 35))
                    }
                    .frame(width: 200)
                    .background(Color.mint)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
            .blur(radius: (game_controller.isGameFinished || isResetPressed) ? 4 : 0 )
            .opacity(isHistoricPressed ? 0 : 1)
            
            Spacer()
        }
    }
    private var top_button : some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isDrawOffered = true
                }
            }) {
                Text("DRAW")
                    .font(Font.system(size: 22))
            }
            .buttonStyle(actionStyle(color: Color.blue))
            .blur(radius: game_controller.game.count_moves <= 2 ? 4 : 0)
            .disabled(game_controller.game.count_moves <= 2 ? true : false)
            
            Spacer()
            
            Button (action: {
                if game_controller.actual_move == "O-O" || game_controller.actual_move == "O-O+" || game_controller.actual_move == "O-O-O" || game_controller.actual_move == "O-O-O+" {
                    game_controller.actual_move = "..."
                } else {
                    game_controller.remove_last()
                }
            }) {
                Text("DELETE")
                    .font(Font.system(size: 22)
                        .bold())
            }
            .buttonStyle(actionStyle(color: Color.mint))
            .blur(radius: (game_controller.isGameFinished || isResetPressed || game_controller.actual_move == "...") ? 4 : 0 )
            .disabled((game_controller.isGameFinished || game_controller.actual_move == "...") ? true : false)
        }
    }
    private var main_buttons: some View {
        VStack {
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
            .blur(radius: isResetPressed ? 4 : 0)
            .blur(radius: game_controller.isGameFinished ? 4 : 0 )
            
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
            .blur(radius: game_controller.isGameFinished ? 4 : 0 ) // MARK: Rank
            .blur(radius: isResetPressed ? 4 : 0)
            
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
            .blur(radius: game_controller.isGameFinished ? 4 : 0 ) // MARK: Pieces
            HStack(spacing: 10) {
                ForEach(moves.footprints_pieces, id: \.self) { footprint in
                    Text(footprint)
                        .font(.footnote)
                        .offset(y: -17)
                }
            }
            .offset(x: -3, y: 20)
        }
    }
    private var actions: some View {
        HStack {
            VStack {
                HStack {
                    ForEach(moves.check, id: \.self) { thatchar in
                        Button(action: {
                            game_controller.add_character("+")
                        }) {
                            Text("+")
                                .cornerRadius(8)
                        }
                        .buttonStyle(actionStyle(color: (game_controller.buttonsController.checkAllowed && game_controller.game.count_moves >= 1) ? Color.blue : Color.gray))
                        .disabled((game_controller.buttonsController.checkAllowed && game_controller.game.count_moves >= 1) ? false : true)
                    }
                    ForEach(moves.mate, id: \.self) { thatchar in
                        Button(action: {
                            game_controller.add_character("#")
                        }) {
                            Text("#")
                                .cornerRadius(8)
                        }
                        .buttonStyle(actionStyle(color: (game_controller.buttonsController.mateAllowed && game_controller.game.count_moves >= 1) ? Color.blue : Color.gray))
                        .disabled((game_controller.buttonsController.mateAllowed && game_controller.game.count_moves >= 1) ? false : true)
                    }
                }
                ForEach(moves.promo, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add_character("=")
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                            .font(Font.system(size: verticalSizeClass == .regular ? 23 : 20))
                            .bold()
                    }
                    .buttonStyle(actionStyle(color: (game_controller.buttonsController.promoAllowed && game_controller.game.count_moves >= 4) ? Color.blue : Color.gray))
                    .disabled((game_controller.buttonsController.promoAllowed && game_controller.game.count_moves >= 4) ? false : true)
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
                    .buttonStyle(actionStyle(color: (game_controller.game.count_moves > 2 && game_controller.buttonsController.rockAllowed) ? Color.blue : Color.gray))
                    .disabled((game_controller.game.count_moves > 2 && game_controller.buttonsController.rockAllowed) ? false : true)
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
        }
        .blur(radius: game_controller.isGameFinished ? 4 : 0 ) // MARK: Actions
        .disabled((game_controller.isGameFinished || isHistoricPressed) ? true : false)
    }
    private var valid: some View {
        Button(action: {
            game_controller.isPairComplete ? game_controller.save_move(move: Move(move: game_controller.actual_move)) : game_controller.save_pair(withMoveSaved: game_controller.coup_saved, andMove: Move(move: game_controller.actual_move))
        }) {
            Text(game_controller.isPairComplete ? "Valider le coup" : "Valider la paire")
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(game_controller.isPairComplete ? Color.blue : Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .blur(radius: (game_controller.isGameFinished || isResetPressed || !game_controller.buttonsController.moveAllowed) ? 4 : 0 )
        .opacity((isHistoricPressed || isMenuPressed) ? 0 : 1)
        .disabled(game_controller.buttonsController.moveAllowed ? false : true)
        .padding(.top)
    }
    private var last_move: some View {
        HStack {
            if game_controller.game.count_moves != 0 {
                Text("\(game_controller.game.pair_Moves.last?.id_ ?? 0). \(game_controller.game.pair_Moves.last?.move_one.move ?? "...") : \(game_controller.game.pair_Moves.last?.move_two.move ?? "...")")
                    .font(Font.system(size: 26))
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(8)
                Spacer()
            } else {
                Text("1. ... : ...")
                    .font(Font.system(size: 26))
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(8)
                Spacer()
            }
        }
        .opacity(isHistoricPressed ? 0 : 1)
    }
    
    private var result_top_buttons: some View {
        HStack {
            if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn") {
                
                ShareLink(item: fileURL) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(Font.system(size: 15))
                }
                .buttonStyle(actionStyle(color: Color.purple))
                .disabled((white_name.isEmpty || black_name.isEmpty) ? true : false)
                .blur(radius: (white_name.isEmpty || black_name.isEmpty) ? 2 : 0 )
            }
            
            Button(action: {
                addGame()
                isSavePressed = true
            }) {
                Text(isSavePressed ? "  ✅  " : "Save")
                    .font(Font.system(size: 15))
            }
            .buttonStyle(actionStyle(color: Color.purple))
            .disabled((white_name.isEmpty || black_name.isEmpty || isSavePressed) ? true : false)
            .blur(radius: (white_name.isEmpty || black_name.isEmpty) ? 2 : 0 )
            
            Button(action: {
                game_controller.newGame()
                resetResult()
                isSavePressed = false
            }) {
                Text("NEW GAME")
                    .font(Font.system(size: 15))
                
            }
            .buttonStyle(actionStyle(color: Color.purple))
        }
    }
    private var result_fields: some View {
        VStack {
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
        }
    }
    private var result_list: some View {
        List {
            ForEach(game_controller.game.pair_Moves) { pair_move in
                HStack {
                    Text("\(pair_move.id_). \(pair_move.move_one.move) : \(pair_move.move_two.move)")
                        .scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip list items here
                }
            }
        }
        .scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip the list itself here
        .scrollContentBackground(.hidden)
    }
    
    private var menu_pressed: some View {
        VStack(alignment: .center) {
            Text("MENU")
                .padding(5)
                .font(.system(size: 40, weight: .bold))
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Divider()
            
            Button(action: {
                isResetPressed.toggle()
            }) {
                Text("Reset")
            }
            
            Button(action: {
                isHistoricPressed.toggle()
            }) {
                Text("Historic")
            }
        }
        .padding()
        .buttonStyle(actionStyle(color: Color.accentColor))
        .frame(width: 250, height: 200)
        .zIndex(isMenuPressed ? 3 : -5)
        .background(Color.mint)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 3)
        )
        .opacity((isResetPressed && isMenuPressed) ? 0 : 1)
    }
    private var reset_pressed: some View {
        VStack {
            Text("Are you sure you want to reset the game?")
                .font(Font.system(size: 35))
                .bold()
                .foregroundStyle(Color.purple)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            HStack {
                Button(action: {
                    game_controller.newGame()
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isResetPressed = false
                        isMenuPressed.toggle()
                    }
                }) {
                    Text("Yes")
                        .font(Font.system(size: 35))
                }
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isResetPressed = false
                    }
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
        .zIndex(isResetPressed ? 4 : -1)
    }
    private var draw_pressed: some View {
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
    }
    private var historic_pressed: some View {
        VStack {
            List {
                ForEach (dataGames, id: \.self) { game in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(game.white_name)")
                                .bold()
                                .font(Font.system(size: 20))
                            Text("\(game.white_elo)")
                                .offset(x: 22)
                                .italic()
                            Text("\(game.black_elo)")
                                .offset(x: 22)
                                .italic()
                            Text("\(game.black_name)")
                                .bold()
                                .font(Font.system(size: 20))
                        }
                        Spacer(minLength: 50)
                        VStack {
                            if game.result == "1/2-1/2" {
                                Text("1/2")
                                Text("-")
                                Text("1/2")
                            } else if game.result == "1-0" {
                                Text("1")
                                Text("-")
                                Text("0")
                            } else if game.result == "0-1" {
                                Text("0")
                                Text("-")
                                Text("1")
                            }
                        }
                        .bold()
                        .font(Font.system(size: 25))
                        
                        VStack(spacing: -10) {
                            Text("\(game.date.formatted(date: .numeric, time: .omitted))")
                            
                            if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Chess Game - \(game.date.formatted(date: .abbreviated, time: .standard)).pgn") {
                                
                                ShareLink(item: fileURL) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                        .font(Font.system(size: 7))
                                }
                                .frame(width: 100, height: 55)
                            }
                            Button(action:  {
                                context.delete(game)
                            }) {
                                Label("Delete", systemImage: "trash")
                                    .font(Font.system(size: 7))
                            }
                            .frame(width: 100, height: 25)
                        }
                        .frame(width: 100)
                    }
                    .cornerRadius(5)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
        .padding()
        .buttonStyle(actionStyle(color: Color.blue))
        .frame(width: 390, height: 630)
        .background(Color.mint)
        .cornerRadius(20)
        .zIndex(isHistoricPressed ? 3 : -1)
    }
    
    var body: some View {
        if verticalSizeClass == .regular { // portrait
            ZStack {
                VStack(spacing: 17) {
                    menu
                    Group {
                        score
                        Spacer(minLength: 20)
                        top_button
                        Divider()
                        main_buttons
                        Divider()
                        actions
                        Spacer(minLength: 20)
                        valid
                    }
                    .disabled((game_controller.isGameFinished || isResetPressed || isMenuPressed) ? true : false)
                    .blur(radius: (game_controller.isGameFinished || isMenuPressed) ? 7 : 0 )
                }
                .zIndex(1)
                .padding()
                
                VStack(alignment: .center, spacing: 20) {
                    result_top_buttons
                    result_fields
                    result_list
                }
                .onSubmit {
                    writeTextToFile(text: game_controller.getPGNContent(forWhite: white_name, andBlack: black_name, result: game_controller.result, event: event, site: site, blackElo: black_elo, whiteElo: white_elo, date: game_controller.game.game_date), fileName: "Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn")
                    if focusedField == .white_n {
                        focusedField = .black_n
                    } else {
                        UIApplication.shared.dismissKeyboard()
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            writeTextToFile(text: game_controller.getPGNContent(forWhite: white_name, andBlack: black_name, result: game_controller.result, event: event, site: site, blackElo: black_elo, whiteElo: white_elo, date: game_controller.game.game_date), fileName: "Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn")
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
                
                if isMenuPressed { menu_pressed }
                
                if isResetPressed { reset_pressed }
                
                if isDrawOffered { draw_pressed }
                
                if isHistoricPressed { historic_pressed }
            }
        } else if verticalSizeClass == .compact { // landscape
            ZStack {
                HStack {
                    VStack(spacing: 17) {
                        main_buttons
                        Divider()
                        actions
                    }.disabled((game_controller.isGameFinished || isResetPressed) ? true : false)
                        .blur(radius: game_controller.isGameFinished ? 4 : 0 )
                        .zIndex(1)
                        .padding()
                    
                    VStack {
                        menu
                        score
                        Spacer()
                        top_button
                        valid
                    }
                    .disabled((game_controller.isGameFinished || isResetPressed) ? true : false)
                    .blur(radius: game_controller.isGameFinished ? 4 : 0 )
                    .zIndex(1)
                    .padding()
                }
                
                HStack(alignment: .center, spacing: 20) {
                    result_fields
                    VStack(spacing: 10) {
                        Spacer(minLength: 30)
                        result_top_buttons
                        result_list
                    }
                }
                .onSubmit {
                    writeTextToFile(text: game_controller.getPGNContent(forWhite: white_name, andBlack: black_name, result: game_controller.result, event: event, site: site, blackElo: black_elo, whiteElo: white_elo, date: game_controller.game.game_date), fileName: "Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn")
                    if focusedField == .white_n {
                        focusedField = .black_n
                    } else {
                        UIApplication.shared.dismissKeyboard()
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            writeTextToFile(text: game_controller.getPGNContent(forWhite: white_name, andBlack: black_name, result: game_controller.result, event: event, site: site, blackElo: black_elo, whiteElo: white_elo, date: game_controller.game.game_date), fileName: "Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn")
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
                .submitLabel(.done)
                .autocorrectionDisabled()
                .padding()
                .background(Color.mint)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.blue, lineWidth: 3)
                )
                .zIndex(game_controller.isGameFinished ? 2 : 0)
                .opacity(game_controller.isGameFinished ? 2 : 0)
                .offset(y: (verticalSizeClass == .regular && isWhiteNameFieldFocused) ? 40 : 0)
                .offset(y: (verticalSizeClass == .compact && isWhiteNameFieldFocused) ? 70 : 0)
                .offset(y: (verticalSizeClass == .compact && isBlackNameFieldFocused) ? 40 : 0)
                
                if isResetPressed { reset_pressed }
                
                if isDrawOffered { draw_pressed }
            }
        }
    }
}

#Preview {
    MoveView()
}
