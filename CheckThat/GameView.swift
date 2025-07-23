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
    @State private var isDrawOffered: Bool = false
    @State private var isResetPressed: Bool = false
    @State private var isHistoricPressed: Bool = false
    @State private var isSavePressed: Bool = false
    @State private var isDeletePressed: Bool = false
    @State private var confirmingDeletion: DataGame? = nil
    
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
                            game: game_controller.getPGNContent(forWhite: white_name, andBlack: black_name, result: game_controller.result, event: event, site: site, blackElo: black_elo, whiteElo: white_elo, date: game_controller.game.game_date))
        context.insert(game)
    }
    
    private var menu_buttons : some View {
        HStack {
            if verticalSizeClass == .compact {
                Spacer(minLength: 100)
                Button(action: {
                    isResetPressed.toggle()
                }) {
                    Text("RESET")
                }
                .padding(5)
                .font(.system(size: 20, weight: .bold))
                .background(isResetPressed ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disabled((isHistoricPressed  || game_controller.isGameFinished) ? true : false)
                .opacity(game_controller.isGameFinished ? 0 : 1)
            } else {
                Button(action: {
                    isResetPressed.toggle()
                }) {
                    Text("RESET")
                }
                .padding(5)
                .font(.system(size: 20, weight: .bold))
                .background(isResetPressed ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disabled((isHistoricPressed  || game_controller.isGameFinished) ? true : false)
                .opacity(game_controller.isGameFinished ? 0 : 1)
                
                Button(action: {
                    isHistoricPressed.toggle()
                }) {
                    Text("HISTORIC")
                }
                .padding(5)
                .font(.system(size: 20, weight: .bold))
                .background(isHistoricPressed ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disabled((isResetPressed || verticalSizeClass == .compact) ? true : false)
                .opacity(verticalSizeClass == .compact ? 0 : 1)
                .blur(radius: isResetPressed ? 4 : 0)
                
                Spacer()
            }
        }
    }
    private var score_view : some View {
        HStack {
            HStack  {
                Text("\(game_controller.game.count_moves == 0 ? "1" : "\(game_controller.game.count_moves + 1)").")
                    .font(Font.system(size: 55))
                    .background(Color.mint)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 70)
                
                VStack(spacing: 15) {
                    HStack() {
                        Text(game_controller.isWhitePlaying ? game_controller.actual_move : game_controller.white_saved_move)
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
                        Text(game_controller.isWhitePlaying ? game_controller.default_ui : game_controller.actual_move)
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
            .opacity((isHistoricPressed && verticalSizeClass  == .regular) ? 0 : 1)
            
            Spacer()
        }
    }
    private var top_buttons : some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isDrawOffered = true
                }
            }) {
                Text("DRAW")
                    .font(Font.system(size: 22))
                    .bold()
            }
            .buttonStyle(actionStyle(color: Color.blue))
            .blur(radius: game_controller.game.count_moves <= 2 ? 2 : 0)
            .disabled(game_controller.game.count_moves <= 2 ? true : false)
            
            Spacer()
            
            Button (action: {
                game_controller.remove()
            }) {
                Text("DELETE")
                    .font(Font.system(size: 22)
                        .bold())
            }
            .buttonStyle(actionStyle(color: Color.mint))
            .blur(radius: (game_controller.isGameFinished || isResetPressed || game_controller.actual_move == game_controller.default_ui) ? 2 : 0 )
            .disabled((game_controller.isGameFinished || game_controller.actual_move == game_controller.default_ui) ? true : false)
        }
    }
    
    private var main_buttons: some View {
        VStack {
            HStack(spacing: 3) {
                ForEach(moves.letters, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add(thatchar)
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(thatStyle(color: game_controller.buttonsController.fileAllowed ? Color.blue : Color.gray))
                    .disabled(game_controller.buttonsController.fileAllowed ? false : true)
                }
            }
            .blur(radius: (game_controller.isGameFinished || isResetPressed) ? 4 : 0 )
            
            HStack(spacing: 3) {
                ForEach(moves.numbers, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add(thatchar)
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(thatStyle(color: game_controller.buttonsController.rankAllowed ? Color.blue : Color.gray))
                    .disabled(game_controller.buttonsController.rankAllowed ? false : true)
                }
            }
            .blur(radius: (game_controller.isGameFinished || isResetPressed) ? 4 : 0 )
            
            HStack {
                ForEach(moves.pieces_letters, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add(thatchar)
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(thatStyle(color: game_controller.buttonsController.piecesAllowed ? Color.blue : Color.gray))
                    .disabled(game_controller.buttonsController.piecesAllowed ? false : true)
                }
                ForEach(moves.king, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add(thatchar)
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(thatStyle(color: game_controller.buttonsController.kingAllowed ? Color.blue : Color.gray))
                    .disabled(game_controller.buttonsController.kingAllowed ? false : true)
                }
            }
            .blur(radius: game_controller.isGameFinished ? 4 : 0 )
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
        VStack {
            HStack {
                VStack {
                    ForEach(moves.small_rock, id: \.self) { thatchar in
                        Button(action: {
                            game_controller.add(thatchar)
                        }) {
                            Text(thatchar)
                                .cornerRadius(8)
                        }
                        .buttonStyle(actionStyle(color: (game_controller.game.count_moves > 2 && game_controller.buttonsController.rockAllowed) ? Color.blue : Color.gray))
                        .disabled((game_controller.game.count_moves > 2 && game_controller.buttonsController.rockAllowed) ? false : true)
                    }
                    ForEach(moves.footprint_small_rock, id: \.self) { footprint in
                        Text(footprint)
                            .font(.footnote)
                    }
                    
                }
                .opacity((game_controller.hasWhiteCastle && game_controller.isWhitePlaying) || (game_controller.hasBlackCastle && !game_controller.isWhitePlaying) ? 0 : 1)
                VStack {
                    ForEach(moves.big_rock, id: \.self) { thatchar in
                        Button(action: {
                            game_controller.add(thatchar)
                        }) {
                            Text(thatchar)
                                .cornerRadius(8)
                        }
                        .buttonStyle(actionStyle(color: (game_controller.game.count_moves > 2 && game_controller.buttonsController.rockAllowed) ? Color.blue : Color.gray))
                        .disabled((game_controller.game.count_moves > 2 && game_controller.buttonsController.rockAllowed) ? false : true)
                    }
                    ForEach(moves.footprint_big_rock, id: \.self) { footprint in
                        Text(footprint)
                            .font(.footnote)
                    }
                }
                .opacity((game_controller.hasWhiteCastle && game_controller.isWhitePlaying) || (game_controller.hasBlackCastle && !game_controller.isWhitePlaying) ? 0 : 1)
                Spacer(minLength: 30)
                VStack {
                    ForEach(moves.promo, id: \.self) { thatchar in
                        Button(action: {
                            game_controller.add(thatchar)
                        }) {
                            Text(thatchar)
                                .cornerRadius(8)
                                .font(Font.system(size: verticalSizeClass == .regular ? 23 : 20))
                                .bold()
                        }
                        .buttonStyle(actionStyle(color: (game_controller.buttonsController.promoAllowed && game_controller.game.count_moves >= 4) ? Color.blue : Color.gray))
                        .disabled((game_controller.buttonsController.promoAllowed && game_controller.game.count_moves >= 4) ? false : true)
                    }
                    ForEach(moves.footprint_promo, id: \.self) { footprint in
                        Text(footprint)
                            .font(.footnote)
                    }
                }
            }
            Divider()
            HStack {
                ForEach(moves.mate, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add("#")
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(takeStyle(color: (game_controller.buttonsController.mateAllowed && game_controller.game.count_moves >= 1) ? Color.blue : Color.gray))
                    .disabled((game_controller.buttonsController.mateAllowed && game_controller.game.count_moves >= 1) ? false : true)
                }
                ForEach(moves.check, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add("+")
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(takeStyle(color: (game_controller.buttonsController.checkAllowed && game_controller.game.count_moves >= 1) ? Color.blue : Color.gray))
                    .disabled((game_controller.buttonsController.checkAllowed && game_controller.game.count_moves >= 1) ? false : true)
                }
                ForEach(moves.take, id: \.self) { thatchar in
                    Button(action: {
                        game_controller.add("x")
                    }) {
                        Text(thatchar)
                            .cornerRadius(8)
                    }
                    .buttonStyle(takeStyle(color: game_controller.buttonsController.takeAllowed  ? Color.blue : Color.gray))
                    .disabled(game_controller.buttonsController.takeAllowed ? false : true)
                    
                }
            }
            .blur(radius: game_controller.isGameFinished ? 4 : 0 )
            .disabled((game_controller.isGameFinished || isHistoricPressed) ? true : false)
        }
    }
    
    private var valid: some View {
        Button(action: {
            game_controller.save()
        }) {
            if (game_controller.isWhitePlaying && game_controller.actual_move.last == "#") {
                Text("tap to valid \n White Won ?")
                    .font(Font.system(size: 30))
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(game_controller.isWhitePlaying ? Color.white : Color.black)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
            } else if (!game_controller.isWhitePlaying && game_controller.actual_move.last == "#") {
                Text("tap to valid \n Black Won ?")
                    .font(Font.system(size: 30))
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(game_controller.isWhitePlaying ? Color.white : Color.black)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
            } else {
                Text("tap to valid")
                    .font(Font.system(size: 30))
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(game_controller.isWhitePlaying ? Color.white : Color.black)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
            }
        }
        .blur(radius: (game_controller.isGameFinished || isResetPressed || !game_controller.buttonsController.moveAllowed) ? 2 : 0 )
        .opacity(( isHistoricPressed && verticalSizeClass  == .regular) ? 0 : 1)
        .disabled(game_controller.buttonsController.moveAllowed ? false : true)
        .padding(.top)
    }
   
    private var result_top_buttons: some View {
        HStack {
            if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Your chess Game - \(game_controller.game.game_date.formatted(date: .abbreviated, time: .standard)).pgn") {
                
                ShareLink(item: fileURL) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(Font.system(size: 15))
                }
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
        }
        .bold()
        .buttonStyle(actionStyle(color: Color(#colorLiteral(red: 0.3820513785, green: 0.5693590045, blue: 0.785138309, alpha: 1))))
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
            ForEach(game_controller.game.moves) { moves in
                HStack {
                    Text("\(moves.number). \(moves.move_white) : \(moves.move_black)")
                        .scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip list items here
                }
            }
        }
        .scaleEffect(x: 1, y: -1, anchor: .center) // 👈 Flip the list itself here
        .scrollContentBackground(.hidden)
    }
    
    private var reset_view: some View {
        VStack {
            Text("Are you sure you want to reset the game?")
                .font(Font.system(size: 35))
                .bold()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            HStack {
                Button(action: {
                    game_controller.newGame()
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isResetPressed = false
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
        .buttonStyle(actionStyle(color: Color.blue))
        .frame(width: 340, height: 230)
        .background(Color.mint)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue, lineWidth: 3)
        )
        .zIndex(isResetPressed ? 3 : -1)
    }
    private var draw_view: some View {
        VStack {
            Text("Are you sure you want to draw the game?")
                .font(Font.system(size: 35))
                .bold()
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
        .buttonStyle(actionStyle(color: Color.blue))
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
    private var historic_view: some View {
        VStack {
            List {
                ForEach (dataGames, id: \.self) { game in
                    GameHistoric(game: game, isConfirming: Binding(
                        get: { confirmingDeletion == game },
                        set: { isConfirming in
                            confirmingDeletion = isConfirming ? game : nil
                        }
                    ))
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
        .padding()
        .buttonStyle(actionStyle(color: Color.blue))
        .frame(width: 390, height: 650)
        .background(Color.mint)
        .cornerRadius(20)
        .zIndex(isHistoricPressed ? 3 : -1)
    }
    
    var body: some View {
        if verticalSizeClass == .regular { // portrait
            ZStack {
                VStack(spacing: 0) {
                    menu_buttons
                    Spacer(minLength: 20)
                    VStack {
                        score_view
                        Spacer(minLength: 20)
                        VStack(spacing: 17) {
                            top_buttons
                            Divider()
                            main_buttons
                            actions
                        }
                        valid
                    }
                    .disabled((game_controller.isGameFinished || isResetPressed) ? true : false)
                    .blur(radius: (game_controller.isGameFinished || isResetPressed) ? 7 : 0 )
                }
                .disabled(isDrawOffered ? true : false)
                .blur(radius: isDrawOffered ? 4 : 0 )
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
                
                if isResetPressed { reset_view }
                
                if isDrawOffered { draw_view }
                
                if isHistoricPressed { historic_view }
            }
        } else if verticalSizeClass == .compact { // landscape
            ZStack {
                HStack {
                    VStack(spacing: 7) {
                        main_buttons
                        Divider()
                        actions
                    }.disabled((game_controller.isGameFinished || isResetPressed) ? true : false)
                        .blur(radius: game_controller.isGameFinished ? 4 : 0 )
                        .zIndex(1)
                        .padding()
                    
                    VStack {
                        menu_buttons
                        score_view
                        Spacer()
                        top_buttons
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
                
                if isResetPressed { reset_view }
                
                if isDrawOffered { draw_view }
            }
        }
    }
}

#Preview {
    MoveView()
}
