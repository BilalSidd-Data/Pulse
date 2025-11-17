//
//  CurrencyConverterView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Currency Converter View
struct CurrencyConverterView: View {
    @State private var solAmount: String = "1.0"
    @State private var eurAmount: String = "150.50"
    @State private var conversionRate: Double = 150.50
    @State private var isConvertingFromSOL: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: "arrow.left.arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.phantomPurple, Color.phantomGold],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Currency Converter")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            // Converter Card
            VStack(spacing: 20) {
                // SOL to EUR
                conversionRow(
                    fromCurrency: "SOL",
                    toCurrency: "EUR",
                    fromAmount: $solAmount,
                    toAmount: $eurAmount,
                    rate: conversionRate,
                    isFrom: true
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // EUR to SOL
                conversionRow(
                    fromCurrency: "EUR",
                    toCurrency: "SOL",
                    fromAmount: $eurAmount,
                    toAmount: $solAmount,
                    rate: 1.0 / conversionRate,
                    isFrom: false
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
                                        Color.phantomPurple.opacity(0.3),
                                        Color.phantomGold.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            
            // Exchange Rate Info
            HStack {
                Spacer()
                Text("1 SOL = €\(String(format: "%.2f", conversionRate))")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
            }
            .padding(.top, 4)
        }
        .onChange(of: solAmount) { oldValue, newValue in
            if isConvertingFromSOL {
                convertSOLToEUR()
            }
        }
        .onChange(of: eurAmount) { oldValue, newValue in
            if !isConvertingFromSOL {
                convertEURToSOL()
            }
        }
        .onAppear {
            updateExchangeRate()
        }
    }
    
    // MARK: - Conversion Row
    private func conversionRow(
        fromCurrency: String,
        toCurrency: String,
        fromAmount: Binding<String>,
        toAmount: Binding<String>,
        rate: Double,
        isFrom: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(fromCurrency)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
                .tracking(1)
            
            HStack {
                TextField("0.0", text: fromAmount)
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .keyboardType(.decimalPad)
                    .disabled(!isFrom)
                    .onChange(of: fromAmount.wrappedValue) { oldValue, newValue in
                        if isFrom {
                            if fromCurrency == "SOL" {
                                isConvertingFromSOL = true
                                convertSOLToEUR()
                            } else {
                                isConvertingFromSOL = false
                                convertEURToSOL()
                            }
                        }
                    }
                
                Spacer()
                
                // Currency badge
                Text(fromCurrency)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.phantomPurple.opacity(0.3),
                                        Color.phantomGold.opacity(0.3)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            }
            
            // Arrow and result
            HStack {
                Image(systemName: "arrow.down")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                
                Text("≈ \(toAmount.wrappedValue) \(toCurrency)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - Convert SOL to EUR
    private func convertSOLToEUR() {
        guard let sol = Double(solAmount), sol >= 0 else {
            eurAmount = "0.00"
            return
        }
        let eur = sol * conversionRate
        eurAmount = String(format: "%.2f", eur)
    }
    
    // MARK: - Convert EUR to SOL
    private func convertEURToSOL() {
        guard let eur = Double(eurAmount), eur >= 0 else {
            solAmount = "0.0"
            return
        }
        let sol = eur / conversionRate
        solAmount = String(format: "%.2f", sol)
    }
    
    // MARK: - Update Exchange Rate
    private func updateExchangeRate() {
        // Simulate fetching real-time rate (in production, this would be an API call)
        // For now, using a fixed rate with slight variation
        conversionRate = 150.50 + Double.random(in: -5...5)
    }
}

// MARK: - Preview
struct CurrencyConverterView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterView()
            .padding()
            .background(Color.deepDark)
            .preferredColorScheme(.dark)
    }
}

