//
//  CardLimitsSection.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Card Limits Section (iOS 18 HIG Compliant)
struct CardLimitsSection: View {
    @State private var solWithdrawn: Double = 0.0
    @State private var eurSpent: Double = 1250.0
    private let solLimit: Double = 10.0
    private let eurLimit: Double = 5000.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Title with icon
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .font(.title3)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.phantomPurple, Color.phantomGold],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Card Limits")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }
            
            // Limits List
            limitsList
            
            // Currency Converter
            CurrencyConverterView()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
    }
    
    // MARK: - Limits List
    private var limitsList: some View {
        VStack(spacing: 20) {
            LimitsRow(
                title: "DAILY SOL WITHDRAWALS",
                current: String(format: "%.1f SOL", solWithdrawn),
                limit: String(format: "%.1f SOL", solLimit),
                progress: solWithdrawn / solLimit,
                isCrypto: true,
                icon: "arrow.up.circle.fill",
                iconColor: Color.phantomPurple
            )
            
            LimitsRow(
                title: "DAILY EUR SPENDING LIMIT",
                current: String(format: "€%.0f", eurSpent),
                limit: String(format: "€%.0f", eurLimit),
                progress: eurSpent / eurLimit,
                isCrypto: false,
                icon: "creditcard.fill",
                iconColor: Color.phantomGold
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.phantomPurple.opacity(0.2),
                                    Color.phantomGold.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Preview
struct CardLimitsSection_Previews: PreviewProvider {
    static var previews: some View {
        CardLimitsSection()
            .padding()
            .background(Color.deepDark)
            .preferredColorScheme(.dark)
    }
}
