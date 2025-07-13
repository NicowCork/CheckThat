//
//  HistoricGameView.swift
//  CheckThat
//
//  Created by Nicolas on 13/07/2025.
//
import SwiftUI

struct GameHistoric: View {
    let game: DataGame
    @Binding var isConfirming: Bool
    @Environment(\.modelContext) private var context

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(game.white_name)")
                    .bold()
                    .font(.system(size: 20))
                Text("\(game.white_elo)")
                    .offset(x: 22)
                    .italic()
                Text("\(game.black_elo)")
                    .offset(x: 22)
                    .italic()
                Text("\(game.black_name)")
                    .bold()
                    .font(.system(size: 20))
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
            .font(.system(size: 25))

            VStack(spacing: -10) {
                Text("\(game.date.formatted(date: .numeric, time: .omitted))")

                if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Chess Game - \(game.date.formatted(date: .abbreviated, time: .standard)).pgn") {
                    ShareLink(item: fileURL) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .font(.system(size: 7))
                    }
                    .frame(width: 100, height: 55)
                }

                if isConfirming {
                    HStack {
                        Button(action: {
                            context.delete(game)
                            try? context.save()
                        }) {
                            Text("✅")
                                .font(.system(size: 10))
                        }
                        Button(action: {
                            isConfirming = false
                        }) {
                            Text("⛔️")
                                .font(.system(size: 10))
                        }
                    }
                    .frame(width: 100, height: 25)
                } else {
                    Button(action: {
                        isConfirming = true
                    }) {
                        Label("Delete", systemImage: "trash")
                            .font(.system(size: 7))
                    }
                    .frame(width: 100, height: 25)
                }
            }
            .frame(width: 100)
        }
        .cornerRadius(5)
    }
}
