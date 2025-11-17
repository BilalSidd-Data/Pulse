//
//  BottomTabBar.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Tab Bar Button (Inspired Design)
struct TabBarButton: View {
    let icon: String
    let label: String
    var isSelected: Bool = false
    let action: () -> Void
    
    // HIG: Minimum touch target is 44x44 points
    private let minTouchTarget: CGFloat = 44
    
    var body: some View {
        Button(action: {
            HapticManager.shared.selection()
            action()
        }) {
            ZStack {
                // Selected background highlight with rounded corners
                if isSelected {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 50)
                        .transition(.scale.combined(with: .opacity))
                }
                
            VStack(spacing: 4) {
                Image(systemName: icon)
                        .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? Color(red: 0.0, green: 0.48, blue: 1.0) : .white)
                        .symbolEffect(.bounce.up, value: isSelected)
                
                Text(label)
                        .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? Color(red: 0.0, green: 0.48, blue: 1.0) : .white)
                }
            }
            .frame(minWidth: minTouchTarget, minHeight: minTouchTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Bottom Tab Bar (Liquid Glass Design)
struct BottomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            // Home Tab
            TabBarButton(
                icon: TabItem.home.icon,
                label: TabItem.home.label,
                isSelected: selectedTab == .home
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = .home
                }
            }
            .frame(maxWidth: .infinity)
            
            // Card Tab
            TabBarButton(
                icon: TabItem.card.icon,
                label: TabItem.card.label,
                isSelected: selectedTab == .card
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = .card
                }
            }
            .frame(maxWidth: .infinity)
            
            // Swap Tab
            TabBarButton(
                icon: TabItem.swap.icon,
                label: TabItem.swap.label,
                isSelected: selectedTab == .swap
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = .swap
                }
            }
            .frame(maxWidth: .infinity)
            
            // Activity Tab
            TabBarButton(
                icon: TabItem.activity.icon,
                label: TabItem.activity.label,
                isSelected: selectedTab == .activity
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = .activity
            }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(height: 65)
        .background {
            // Liquid glass effect with dark translucent background
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.15).opacity(0.8))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
        }
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 5)
        .padding(.horizontal, 16)
    }
}
