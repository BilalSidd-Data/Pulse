//
//  CardFrontView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Card Front View (Hidden and Revealed Details)
struct CardFrontView: View {
    let isRevealed: Bool
    let onCopy: () -> Void
    
    @State private var showCardNumber = false
    @State private var showExpiry = false
    @State private var showCCV = false
    
    var body: some View {
        Group {
            if isRevealed {
                revealedView
            } else {
                hiddenView
            }
        }
        .onChange(of: isRevealed) { oldValue, newValue in
            if newValue {
                // Staggered reveal animation - elements appear one by one
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1)) {
                    showCardNumber = true
                }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3)) {
                    showExpiry = true
                }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.4)) {
                    showCCV = true
                }
            } else {
                // Quick hide animation
                withAnimation(.easeOut(duration: 0.2)) {
                    showCardNumber = false
                    showExpiry = false
                    showCCV = false
                }
            }
        }
        .onAppear {
            // Initialize state when view appears
            if isRevealed {
                showCardNumber = true
                showExpiry = true
                showCCV = true
            }
        }
    }
    
    // MARK: - Hidden View
    private var hiddenView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Cardholder Name with subtle glow
            Text("M BILAL SIDDIQUI")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.white, Color.white.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: Color.white.opacity(0.3), radius: 4)
                .padding(.bottom, 4)
            
            // Card Number (Masked) and VISA Logo
            HStack {
                Text("•••• 7553")
                    .font(.system(size: 24, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                    .tracking(2)
                
                Spacer()
                
                // Enhanced VISA logo
                ZStack {
                    // Glow effect
                    Text("VISA")
                        .font(.system(size: 28))
                        .fontWeight(.black)
                        .italic()
                        .foregroundColor(.white)
                        .blur(radius: 6)
                        .opacity(0.4)
                    
                    // Main VISA text
                    Text("VISA")
                        .font(.system(size: 28))
                        .fontWeight(.black)
                        .italic()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.white, Color.phantomGold],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
    
    // MARK: - Revealed View
    private var revealedView: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Card Number Section with animation
            cardNumberSection
                .opacity(showCardNumber ? 1 : 0)
                .offset(y: showCardNumber ? 0 : 20)
                .scaleEffect(showCardNumber ? 1 : 0.8)
            
            // Expiry and CCV Section with separate animations
            HStack(spacing: 32) {
                expiryDateView
                    .opacity(showExpiry ? 1 : 0)
                    .offset(x: showExpiry ? 0 : -20)
                    .scaleEffect(showExpiry ? 1 : 0.8)
                
                ccvView
                    .opacity(showCCV ? 1 : 0)
                    .offset(x: showCCV ? 0 : 20)
                    .scaleEffect(showCCV ? 1 : 0.8)
            }
        }
    }
    
    // MARK: - Card Number Section
    private var cardNumberSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CARD NUMBER")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
                .tracking(1)
            
            HStack(spacing: 12) {
                Text("4256 7890 4456 7553")
                    .font(.system(size: 22, weight: .semibold, design: .monospaced))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.white, Color.phantomPurple.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .tracking(2)
                    .shadow(color: Color.phantomPurple.opacity(0.5), radius: 8)
                
                copyButton
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Copy Button
    private var copyButton: some View {
        Button(action: {
            HapticManager.shared.selection()
            onCopy()
        }) {
            ZStack {
                // Glow effect
                Circle()
                    .fill(Color.phantomPurple.opacity(0.3))
                    .frame(width: 36, height: 36)
                    .blur(radius: 4)
                
                // Main button
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.phantomPurple.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Copy card number")
    }
    
    // MARK: - Expiry and CCV Section
    private var expiryAndCCVSection: some View {
        HStack(spacing: 32) {
            expiryDateView
            ccvView
        }
    }
    
    // MARK: - Expiry Date View
    private var expiryDateView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("EXPIRY")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
                .tracking(1)
            Text("09/28")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.white, Color.white.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: Color.white.opacity(0.3), radius: 4)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    // MARK: - CCV View
    private var ccvView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("CCV")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
                .tracking(1)
            Text("667")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.white, Color.white.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: Color.white.opacity(0.3), radius: 4)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            CardFrontView(isRevealed: false, onCopy: {
                print("Copy tapped")
            })
            
            CardFrontView(isRevealed: true, onCopy: {
                print("Copy tapped")
            })
        }
        .padding()
        .background(Color.cardDark)
        .preferredColorScheme(.dark)
    }
}
