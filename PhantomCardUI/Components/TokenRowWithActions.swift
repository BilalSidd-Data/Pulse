//
//  TokenRowWithActions.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Token Row With Actions
struct TokenRowWithActions: View {
    let token: Token
    let onChartTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Token Icon
            ZStack {
                Circle()
                    .fill(token.color.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: token.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(token.color)
            }
            
            // Token Info
            VStack(alignment: .leading, spacing: 4) {
                Text(token.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("\(String(format: "%.2f", token.balance)) \(token.symbol)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Value and Change
            VStack(alignment: .trailing, spacing: 4) {
                Text(CurrencyFormatter.shared.formatWithSymbol(token.balanceInUSD))
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: token.change24h >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption2)
                        .foregroundColor(token.change24h >= 0 ? .green : .red)
                    
                    Text("\(token.change24h >= 0 ? "+" : "")\(String(format: "%.2f", token.change24h))%")
                        .font(.caption)
                        .foregroundColor(token.change24h >= 0 ? .green : .red)
                }
            }
            
            // Action Buttons
            HStack(spacing: 8) {
                // Chart Button
                Button {
                    HapticManager.shared.selection()
                    onChartTap()
                } label: {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.caption)
                        .foregroundColor(.phantomPurple)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color.phantomPurple.opacity(0.2))
                        )
                }
            }
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

