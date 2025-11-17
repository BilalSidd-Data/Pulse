//
//  FlippableCardView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Flippable Card View (3D Flip Animation)
struct FlippableCardView: View {
    let isFlipped: Bool
    let onCopy: () -> Void
    var scrollProgress: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            // FRONT of card with revealed or hidden details
            // When isFlipped is true, show revealed details on front (not flip to back)
            CardFrontSide(
                isRevealed: isFlipped,
                onCopy: onCopy,
                scrollProgress: scrollProgress
            )
        }
        .frame(width: 340, height: 520)
        .onChange(of: isFlipped) { oldValue, newValue in
            HapticManager.shared.impact(.medium)
        }
    }
}

// MARK: - Card Front Side (Shows revealed or hidden)
struct CardFrontSide: View {
    let isRevealed: Bool
    let onCopy: () -> Void
    var scrollProgress: CGFloat = 0.0
    
    // Parallax offset for content
    private var contentParallax: CGFloat {
        return scrollProgress * 30
    }
    
    // Blur effect based on scroll (subtle)
    private var blurRadius: CGFloat {
        return scrollProgress * 2
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            CardBackgroundView(scrollProgress: scrollProgress)
            
            VStack(alignment: .leading, spacing: 24) {
                CardHeaderView(scrollProgress: scrollProgress)
                    .offset(y: -contentParallax * 0.3)
                    .opacity(1.0 - scrollProgress * 0.3)
                
                Spacer()
                
                // Show revealed details or masked details with smooth transition
                CardFrontView(isRevealed: isRevealed, onCopy: onCopy)
                    .offset(y: contentParallax * 0.5)
                    .blur(radius: blurRadius)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.9)).combined(with: .move(edge: .bottom)),
                        removal: .opacity.combined(with: .scale(scale: 1.1))
                    ))
            }
            .padding(28)
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.75), value: isRevealed)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: scrollProgress)
    }
}

// MARK: - Preview
struct FlippableCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            // Front (hidden)
            FlippableCardView(isFlipped: false, onCopy: { print("Copy") })
            
            // Front (revealed)
            FlippableCardView(isFlipped: true, onCopy: { print("Copy") })
        }
        .padding()
        .background(Color.deepDark)
        .preferredColorScheme(.dark)
    }
}
