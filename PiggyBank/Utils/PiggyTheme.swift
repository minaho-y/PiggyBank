//
//  PiggyTheme.swift
//  PiggyBank
//
//  Created by Minaho Yamasaki on 2026/05/11.
//

import SwiftUI

enum PiggyTheme {
    static let primary = Color(red: 0.97, green: 0.40, blue: 0.58)
    static let primaryStrong = Color(red: 0.94, green: 0.30, blue: 0.50)
    static let primarySoft = Color(red: 0.99, green: 0.86, blue: 0.91)
    static let textPrimary = Color(red: 0.25, green: 0.18, blue: 0.25)
    static let textSecondary = Color(red: 0.49, green: 0.40, blue: 0.46)
    static let line = Color(red: 0.98, green: 0.82, blue: 0.87)
    static let progressTrack = Color(red: 0.94, green: 0.94, blue: 0.94)
    
    static let buttonGradient = LinearGradient(
        colors: [primary, primaryStrong],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct PiggyCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 8)
    }
}

struct PiggyPrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .foregroundStyle(.white)
            .background(PiggyTheme.buttonGradient)
            .clipShape(Capsule())
    }
}

extension View {
    func piggyCardStyle() -> some View {
        modifier(PiggyCardModifier())
    }
}

extension View {
    func piggyPrimaryButtonStyle() -> some View {
        modifier(PiggyPrimaryButtonModifier())
    }
}
