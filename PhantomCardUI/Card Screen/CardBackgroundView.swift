//
//  CardBackgroundView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Card Background View
struct CardBackgroundView: View {
    @State private var shimmerOffset: CGFloat = -200
    var scrollProgress: CGFloat = 0.0
    
    // Dynamic gradient shift based on scroll
    private var gradientShift: CGFloat {
        return scrollProgress * 0.3
    }
    
    // Glow intensity based on scroll
    private var glowOpacity: CGFloat {
        return 0.2 - (scrollProgress * 0.15)
    }
    
    // Parallax for background elements
    private var backgroundParallax: CGFloat {
        return scrollProgress * 40
    }
    
    var body: some View {
        ZStack {
            // Base gradient background with dynamic shift
            RoundedRectangle(cornerRadius: 26)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.cardDark,
                            Color.cardDark.opacity(0.95),
                            Color(red: 0.12, green: 0.12, blue: 0.15)
                        ],
                        startPoint: UnitPoint(
                            x: 0.0 + gradientShift,
                            y: 0.0 + gradientShift
                        ),
                        endPoint: UnitPoint(
                            x: 1.0 - gradientShift,
                            y: 1.0 - gradientShift
                        )
                    )
                )
            
            // Subtle radial gradient overlay with parallax
            RoundedRectangle(cornerRadius: 26)
                .fill(
                    RadialGradient(
                        colors: [
                            Color.phantomPurple.opacity(0.15 - scrollProgress * 0.1),
                            Color.clear
                        ],
                        center: UnitPoint(
                            x: 0.0 + gradientShift * 0.5,
                            y: 0.0 + gradientShift * 0.5
                        ),
                        startRadius: 50,
                        endRadius: 300
                    )
                )
            
            // Pattern overlay with parallax
            cardPatternOverlay
                .offset(y: backgroundParallax * 0.5)
                .opacity(1.0 - scrollProgress * 0.5)
            
            // Shimmer effect with scroll-based intensity
            shimmerEffect
                .opacity(1.0 - scrollProgress * 0.6)
            
            // Scroll-based particle effect
            scrollParticleEffect
        }
        .overlay(
            // Border glow with dynamic intensity
            RoundedRectangle(cornerRadius: 26)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1 - scrollProgress * 0.05),
                            Color.phantomPurple.opacity(0.3 - scrollProgress * 0.1),
                            Color.white.opacity(0.1 - scrollProgress * 0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1 + scrollProgress * 0.5
                )
        )
        .shadow(color: Color.black.opacity(0.4 - scrollProgress * 0.2), radius: 20 - scrollProgress * 10, x: 0, y: 10 - scrollProgress * 5)
        .shadow(color: Color.phantomPurple.opacity(glowOpacity), radius: 30 - scrollProgress * 15, x: 0, y: 15 - scrollProgress * 8)
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                shimmerOffset = 400
            }
        }
    }
    
    // MARK: - Card Pattern Overlay
    private var cardPatternOverlay: some View {
        ZStack {
            // Multiple pattern layers for depth
            ForEach(0..<3, id: \.self) { index in
                Image(systemName: "square.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white.opacity(0.03 - Double(index) * 0.01))
                    .rotationEffect(.degrees(45))
                    .offset(x: CGFloat(index * 20) + 10, y: 150 + CGFloat(index * 30))
                    .scaleEffect(1.0 + CGFloat(index) * 0.2)
            }
        }
    }
    
    // MARK: - Shimmer Effect
    private var shimmerEffect: some View {
        LinearGradient(
            colors: [
                Color.clear,
                Color.white.opacity(0.1),
                Color.clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: 100)
        .offset(x: shimmerOffset)
        .rotationEffect(.degrees(-45))
        .blur(radius: 20)
    }
    
    // MARK: - Scroll Particle Effect
    private var scrollParticleEffect: some View {
        ZStack {
            // Multiple particles that appear/disappear based on scroll
            ForEach(0..<5, id: \.self) { index in
                let size = CGFloat(4) + CGFloat(index) * 0.8
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.phantomPurple.opacity(0.3),
                                Color.phantomGold.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size, height: size)
                    .offset(
                        x: CGFloat(index * 60 - 120) + scrollProgress * 20,
                        y: CGFloat(index * 40 - 80) + scrollProgress * 30
                    )
                    .opacity(scrollProgress > 0.3 ? scrollProgress * 0.5 : 0)
                    .blur(radius: 2)
            }
        }
    }
}

// MARK: - Preview
struct CardBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CardBackgroundView()
            .frame(width: 280, height: 430)
            .preferredColorScheme(.dark)
    }
}
