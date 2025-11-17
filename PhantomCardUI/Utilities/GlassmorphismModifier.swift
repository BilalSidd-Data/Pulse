//
//  GlassmorphismModifier.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Glassmorphism Modifier
struct GlassmorphismModifier: ViewModifier {
    var opacity: Double = 0.15
    var blur: CGFloat = 10
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Frosted glass effect
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(opacity))
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                        )
                    
                    // Subtle border
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                }
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

// MARK: - View Extension
extension View {
    func glassmorphism(opacity: Double = 0.15, blur: CGFloat = 10) -> some View {
        modifier(GlassmorphismModifier(opacity: opacity, blur: blur))
    }
}
