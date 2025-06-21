//
//  ViewModifiers.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import SwiftUI

struct thatStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 28, weight: .bold))
            .frame(width: 50, height: 50)
            .background(configuration.isPressed ? Color.gray.opacity(0.3) : Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct actionStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .bold()
            .foregroundStyle(.white)
            .background(Color.indigo)
            .clipShape(Capsule(style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}
