//
//  StickyCardView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

struct StickyCardView: View {
    let progress: CGFloat
    let isRevealed: Bool
    let onCopy: () -> Void
    
    // Card shrinks from 100% to 30% as you scroll
    private var cardScale: CGFloat {
        let minScale: CGFloat = 0.3
        let maxScale: CGFloat = 1.0
        return maxScale - (progress * (maxScale - minScale))
    }
    
    // Card moves up as you scroll
    private var yOffset: CGFloat {
        return -progress * 180
    }
    
    // Card slightly fades as you scroll
    private var cardOpacity: CGFloat {
        return 1.0 - (progress * 0.2)
    }
    
    // 3D rotation based on scroll
    private var rotationX: Double {
        return Double(progress * 15) // Tilt forward as you scroll
    }
    
    // Parallax offset for background
    private var parallaxOffset: CGFloat {
        return progress * 50
    }
    
    // Glow intensity based on scroll
    private var glowIntensity: CGFloat {
        return 1.0 - (progress * 0.5)
    }
    
    var body: some View {
        CardView(
            isRevealed: isRevealed,
            onCopy: onCopy,
            scrollProgress: progress
        )
        .scaleEffect(cardScale)
        .offset(y: yOffset)
        .opacity(cardOpacity)
        .rotation3DEffect(
            .degrees(rotationX),
            axis: (x: 1, y: 0, z: 0),
            perspective: 0.5
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.75), value: progress)
    }
}

// MARK: - Preview
struct StickyCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            // Normal state (not scrolled)
            StickyCardView(
                progress: 0,
                isRevealed: false,
                onCopy: { print("Copy tapped") }
            )
            
            // Scrolled state
            StickyCardView(
                progress: 1.0,
                isRevealed: false,
                onCopy: { print("Copy tapped") }
            )
        }
        .padding()
        .background(Color.deepDark)
        .preferredColorScheme(.dark)
    }
}
