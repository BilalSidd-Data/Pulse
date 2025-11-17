//
//  HeaderView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Header View
struct HeaderView: View {
    let onAddTapped: () -> Void
    let onNotificationsTapped: () -> Void
    let hasUnreadNotifications: Bool
    var onSettingsTapped: (() -> Void)? = nil
    
    @State private var addButtonTapped = false
    @State private var notificationButtonTapped = false
    
    var body: some View {
        HStack {
            // User Avatar (MS) - using Gold accent
            Button(action: {
                HapticManager.shared.selection()
                onSettingsTapped?()
            }) {
                Text("MS")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [Color.phantomGold, Color.phantomGold.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1.5)
                    )
                    .shadow(color: Color.phantomGold.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Top Right Icons
            HStack(spacing: 12) {
                // Add Button - Enhanced with glassmorphism and gradient
                Button(action: {
                    HapticManager.shared.impact(.medium)
                    addButtonTapped.toggle()
                    onAddTapped()
                }) {
                    ZStack {
                        // Glassmorphism background
                        Circle()
                            .fill(.ultraThinMaterial)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.phantomPurple.opacity(0.3),
                                                Color.phantomPurple.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.phantomPurple.opacity(0.4),
                                                Color.phantomPurple.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .frame(width: 44, height: 44)
                        
                        // Icon with gradient
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color.phantomPurple,
                                        Color.phantomPurple.opacity(0.8)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .symbolEffect(.bounce, value: addButtonTapped)
                    }
                    .shadow(color: Color.phantomPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(HeaderButtonStyle())
                
                // Notifications Button - Enhanced with glassmorphism and gradient
                Button(action: {
                    HapticManager.shared.impact(.medium)
                    notificationButtonTapped.toggle()
                    onNotificationsTapped()
                }) {
                    ZStack {
                        // Glassmorphism background
                        Circle()
                            .fill(.ultraThinMaterial)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.phantomGold.opacity(0.3),
                                                Color.phantomGold.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.phantomGold.opacity(0.4),
                                                Color.phantomGold.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .frame(width: 44, height: 44)
                        
                        ZStack {
                            // Icon with gradient
                            Image(systemName: "bell.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.phantomGold,
                                            Color.phantomGold.opacity(0.8)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .symbolEffect(.bounce, value: notificationButtonTapped)
                            
                            // Enhanced Badge with pulse animation
                            if hasUnreadNotifications {
                                NotificationBadgeView()
                                    .offset(x: 10, y: -10)
                            }
                        }
                    }
                    .shadow(color: Color.phantomGold.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(HeaderButtonStyle())
            }
        }
        .padding(.top, 10)
    }
}

// MARK: - Header Button Style
struct HeaderButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Notification Badge View
struct NotificationBadgeView: View {
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            // Outer glow with pulse animation
            Circle()
                .fill(Color.phantomPurple.opacity(isPulsing ? 0.5 : 0.3))
                .frame(width: isPulsing ? 14 : 12, height: isPulsing ? 14 : 12)
                .blur(radius: 2)
            
            // Badge
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.phantomPurple,
                            Color.phantomPurple.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 10, height: 10)
                .overlay(
                    Circle()
                        .stroke(Color.deepDark, lineWidth: 2)
                )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}
