//
//  CardView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Card View (With Flip Animation)
struct CardView: View {
    let isRevealed: Bool
    let onCopy: () -> Void
    var scrollProgress: CGFloat = 0.0

    var body: some View {
        FlippableCardView(
            isFlipped: isRevealed,
            onCopy: onCopy,
            scrollProgress: scrollProgress
        )
    }
}

// MARK: - Preview
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            CardView(isRevealed: false, onCopy: {
                print("Copy tapped")
            })
            
            CardView(isRevealed: true, onCopy: {
                print("Copy tapped")
            })
        }
        .padding()
        .background(Color.deepDark)
        .preferredColorScheme(.dark)
    }
}
