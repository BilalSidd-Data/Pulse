//
//  LiquidGlassTabBarModifier.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI
import UIKit

// MARK: - Liquid Glass Tab Bar Modifier
struct LiquidGlassTabBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                configureLiquidGlassTabBar()
            }
    }
    
    private func configureLiquidGlassTabBar() {
        // Create appearance configuration
        let appearance = UITabBarAppearance()
        
        // Configure with transparent background for true liquid glass effect
        appearance.configureWithTransparentBackground()
        
        // Use ultra-thin material dark for liquid glass blur effect
        // This creates the frosted glass appearance native to iOS
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        
        // Add subtle dark tint for better contrast and glass effect
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        
        // Selected tab styling - iOS native system blue
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        // Normal tab styling - subtle white with transparency
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.65)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.65),
            .font: UIFont.systemFont(ofSize: 10, weight: .regular)
        ]
        
        // Remove default shadow for cleaner look
        appearance.shadowColor = UIColor.clear
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        
        // Apply appearance to tab bar
        UITabBar.appearance().standardAppearance = appearance
        
        // Apply to scroll edge appearance for iOS 15+
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Make tab bar translucent to show blur effect
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().barTintColor = UIColor.clear
        
        // Allow blur to extend beyond bounds for liquid effect
        UITabBar.appearance().clipsToBounds = false
    }
}

extension View {
    func liquidGlassTabBar() -> some View {
        self.modifier(LiquidGlassTabBarModifier())
    }
}

