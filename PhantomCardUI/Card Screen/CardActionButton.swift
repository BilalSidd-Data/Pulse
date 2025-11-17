//
//  CardActionButton.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Card Action Button
struct CardActionButton: View {
    let iconName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.shared.selection()
            action()
        }) {
            VStack(spacing: 10) {
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .semibold))
                    .frame(width: 60, height: 60)
                    .background(
                        LinearGradient(
                            colors: [Color.cardDark, Color.cardDark.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 1.5)
                    )
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}
