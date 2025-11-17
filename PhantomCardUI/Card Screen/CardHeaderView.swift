//
//  CardHeaderView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Card Header View
struct CardHeaderView: View {
    @State private var logoScale: CGFloat = 1.0
    var scrollProgress: CGFloat = 0.0
    
    // Logo rotation based on scroll
    private var logoRotation: Double {
        return Double(scrollProgress * 10)
    }
    
    // Chip scale based on scroll
    private var chipScale: CGFloat {
        return 1.0 - (scrollProgress * 0.2)
    }
    
    var body: some View {
        HStack {
            // App Logo with glow effect and scroll animation
            ZStack {
                // Glow behind logo
                Text("M")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .blur(radius: 8)
                    .opacity(0.5 - scrollProgress * 0.3)
                
                // Main logo
                Text("M")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.white, Color.phantomPurple.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(logoRotation))
            }
            .scaleEffect(logoScale * (1.0 - scrollProgress * 0.1))
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    logoScale = 1.05
                }
            }
            
            Spacer()
            
            // Chip Icon with enhanced styling and scroll animation
            ZStack {
                // Glow effect
                Image(systemName: "creditcard.and.123")
                    .resizable()
                    .frame(width: 32, height: 25)
                    .foregroundColor(.white)
                    .blur(radius: 4)
                    .opacity(0.3 - scrollProgress * 0.2)
                
                // Main chip icon
                Image(systemName: "creditcard.and.123")
                    .resizable()
                    .frame(width: 32, height: 25)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.white, Color.phantomGold.opacity(0.9)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(chipScale)
        }
    }
}

// MARK: - Preview
struct CardHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CardHeaderView()
            .padding()
            .background(Color.cardDark)
            .preferredColorScheme(.dark)
    }
}
