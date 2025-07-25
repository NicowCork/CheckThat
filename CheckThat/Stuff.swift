//
//  ViewModifiers.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import SwiftUI
import AVFoundation

struct thatStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 28, weight: .bold))
            .frame(width: 47, height: 47)
            .background(color)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct actionStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 23, weight: .bold))
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .foregroundStyle(.white)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct takeStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 90, height: 83)
            .font(.system(size: 23, weight: .bold))
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .foregroundStyle(.white)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

var audioPlayer: AVAudioPlayer?
func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR")
        }
    }
}

func writeTextToFile(text: String, fileName: String) {
    guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let fileURL = dir.appendingPathComponent(fileName)

do {
        try text.write(to: fileURL, atomically: true, encoding: .utf8)
        print("File written to: \(fileURL)")
    } catch {
        print("Error writing file: \(error.localizedDescription)")
    }
}
