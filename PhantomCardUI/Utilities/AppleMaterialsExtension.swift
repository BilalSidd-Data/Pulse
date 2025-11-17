//
//  AppleMaterialsExtension.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// Apple HIG-compliant materials and modifiers
extension View {
    /// Applies iOS 18 style card appearance with proper materials
    func cardStyle() -> some View {
        self
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(.white.opacity(0.1), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    /// Applies iOS 18 style grouped list background
    func groupedListStyle() -> some View {
        self
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(.white.opacity(0.08), lineWidth: 0.5)
            )
    }
    
    /// Applies iOS 18 sheet background
    func sheetBackground() -> some View {
        self
            .background(
                ZStack {
                    // iOS 18 gradient background
                    LinearGradient(
                        colors: [
                            Color(uiColor: .systemBackground),
                            Color(uiColor: .secondarySystemBackground)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .ignoresSafeArea()
            )
    }
}

// iOS 18 Haptic Feedback
class HapticManager {
    static let shared = HapticManager()
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
