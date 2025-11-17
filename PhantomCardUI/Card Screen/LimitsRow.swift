//
//  LimitsRow.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Limits Row
struct LimitsRow: View {
    let title: String
    let current: String
    let limit: String
    let progress: Double
    var isCrypto: Bool = false
    var icon: String = "chart.bar.fill"
    var iconColor: Color = Color.phantomPurple
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with icon
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                    .tracking(0.5)
                
                Spacer()
                
                // Percentage
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(progressColor)
            }
            
            // Amounts
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Used")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text(current)
                        .font(.system(size: 20, weight: .bold, design: isCrypto ? .monospaced : .default))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.white, iconColor.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Limit")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text(limit)
                        .font(.system(size: 20, weight: .semibold, design: isCrypto ? .monospaced : .default))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // Enhanced Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.cardDark)
                        .frame(height: 8)
                    
                    // Progress fill with gradient
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [
                                    iconColor,
                                    iconColor.opacity(0.7),
                                    iconColor.opacity(0.5)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: min(geometry.size.width * progress, geometry.size.width), height: 8)
                        .shadow(color: iconColor.opacity(0.5), radius: 4)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Progress Color
    private var progressColor: Color {
        if progress < 0.5 {
            return .green
        } else if progress < 0.8 {
            return .orange
        } else {
            return .red
        }
    }
}
