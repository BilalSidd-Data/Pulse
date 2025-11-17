//
//  SwapView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Swap View
struct SwapView: View {
    @EnvironmentObject private var appState: AppStateManager
    @State private var fromToken: Token?
    @State private var toToken: Token?
    @State private var fromAmount: String = ""
    @State private var toAmount: String = ""
    @State private var exchangeRate: Double = 0
    @State private var isSelectingFromToken = false
    @State private var isSelectingToToken = false
    @State private var isConfirmingSwap = false
    
    private var availableTokens: [Token] {
        appState.allTokens
    }
    
    // Get current tokens with live prices
    private var currentFromToken: Token? {
        guard let fromToken = fromToken else { return nil }
        return appState.allTokens.first { $0.symbol == fromToken.symbol }
    }
    
    private var currentToToken: Token? {
        guard let toToken = toToken else { return nil }
        return appState.allTokens.first { $0.symbol == toToken.symbol }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HeaderView(
                    onAddTapped: {},
                    onNotificationsTapped: {},
                    hasUnreadNotifications: false,
                    onSettingsTapped: nil
                )
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Swap Card
                swapCard
                
                // Exchange Rate Info
                exchangeRateInfo
                
                // Swap Button
                swapButton
                
                Spacer(minLength: 120)
            }
            .padding(.top, 8)
            .padding(.horizontal, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .scrollIndicators(.hidden)
        .background(Color.deepDark.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isSelectingFromToken) {
            TokenSelectionView(
                isPresented: $isSelectingFromToken,
                selectedToken: Binding(
                    get: { fromToken ?? availableTokens.first ?? Token.topCryptocurrencies.first! },
                    set: { newToken in
                        // Get the updated version with live prices
                        if let updatedToken = appState.allTokens.first(where: { $0.symbol == newToken.symbol }) {
                            fromToken = updatedToken
                        } else {
                            fromToken = newToken
                        }
                    }
                ),
                availableTokens: availableTokens
            )
        }
        .sheet(isPresented: $isSelectingToToken) {
            TokenSelectionView(
                isPresented: $isSelectingToToken,
                selectedToken: Binding(
                    get: { toToken ?? availableTokens[1] },
                    set: { newToken in
                        // Get the updated version with live prices
                        if let updatedToken = appState.allTokens.first(where: { $0.symbol == newToken.symbol }) {
                            toToken = updatedToken
                        } else {
                            toToken = newToken
                        }
                    }
                ),
                availableTokens: availableTokens
            )
        }
        .sheet(isPresented: $isConfirmingSwap) {
            if let fromToken = currentFromToken, let toToken = currentToToken {
                SwapConfirmationView(
                    isPresented: $isConfirmingSwap,
                    fromToken: fromToken,
                    toToken: toToken,
                    fromAmount: fromAmount,
                    toAmount: toAmount
                )
            }
        }
        .onAppear {
            // Initialize tokens from appState with live prices
            if fromToken == nil, let first = appState.allTokens.first {
                fromToken = first
            }
            if toToken == nil, appState.allTokens.count > 1 {
                toToken = appState.allTokens[1]
            }
        }
        .onChange(of: fromAmount) { oldValue, newValue in
            calculateToAmount()
        }
        .onChange(of: fromToken) { oldValue, newValue in
            calculateToAmount()
        }
        .onChange(of: toToken) { oldValue, newValue in
            calculateToAmount()
        }
        .onChange(of: appState.allTokens) { oldValue, newValue in
            // Sync prices when allTokens updates with live prices
            syncTokenPrices()
            calculateToAmount()
        }
    }
    
    // MARK: - Sync Token Prices
    private func syncTokenPrices() {
        // Update fromToken with latest price
        if let fromSymbol = fromToken?.symbol,
           let updatedToken = appState.allTokens.first(where: { $0.symbol == fromSymbol }) {
            fromToken = updatedToken
        }
        
        // Update toToken with latest price
        if let toSymbol = toToken?.symbol,
           let updatedToken = appState.allTokens.first(where: { $0.symbol == toSymbol }) {
            toToken = updatedToken
        }
    }
    
    // MARK: - Swap Card
    private var swapCard: some View {
        Group {
            if let fromToken = currentFromToken, let toToken = currentToToken {
                VStack(spacing: 0) {
                    // From Token
                    swapTokenRow(
                        token: fromToken,
                        amount: $fromAmount,
                        isFrom: true,
                        onTokenTap: {
                            isSelectingFromToken = true
                        }
                    )
                    
                    // Swap Arrow Button
                    Button(action: {
                        HapticManager.shared.selection()
                        swapTokens()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.phantomPurple.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.phantomPurple)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // To Token
                    swapTokenRow(
                        token: toToken,
                        amount: $toAmount,
                        isFrom: false,
                        onTokenTap: {
                            isSelectingToToken = true
                        }
                    )
                }
                .padding(20)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
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
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Swap Token Row
    private func swapTokenRow(
        token: Token,
        amount: Binding<String>,
        isFrom: Bool,
        onTokenTap: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(isFrom ? "From" : "To")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
                .tracking(1)
            
            HStack {
                TextField("0.0", text: amount)
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .keyboardType(.decimalPad)
                    .disabled(!isFrom)
                
                Spacer()
                
                // Token Selector
                Button(action: onTokenTap) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(token.color.opacity(0.2))
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: token.icon)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(token.color)
                        }
                        
                        Text(token.symbol)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                    )
                }
            }
            
            if isFrom {
                HStack {
                    Text("Balance: \(String(format: "%.2f", token.balance)) \(token.symbol)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Spacer()
                    
                    Button("Max") {
                        amount.wrappedValue = String(format: "%.2f", token.balance)
                        HapticManager.shared.selection()
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.phantomPurple)
                }
            }
        }
    }
    
    // MARK: - Exchange Rate Info
    private var exchangeRateInfo: some View {
        HStack {
            Spacer()
            VStack(spacing: 4) {
                Text("Exchange Rate")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                
                Group {
                    if let fromToken = currentFromToken,
                       let toToken = currentToToken,
                       exchangeRate > 0 {
                        VStack(spacing: 4) {
                            Text("1 \(fromToken.symbol) = \(formatRate(exchangeRate)) \(toToken.symbol)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            // Show EUR equivalent with live price
                            Text("≈ \(CurrencyFormatter.shared.formatWithSymbol(fromToken.price))")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    } else {
                        Text("Enter amount to see rate")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Swap Button
    private var swapButton: some View {
        Button {
            HapticManager.shared.impact(.medium)
            isConfirmingSwap = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 16, weight: .medium))
                
                Text("Review Swap")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.phantomPurple.opacity(0.85))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                    )
            )
            .shadow(color: Color.phantomPurple.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .disabled(fromAmount.isEmpty || Double(fromAmount) == nil || Double(fromAmount)! <= 0)
        .opacity(fromAmount.isEmpty || Double(fromAmount) == nil || Double(fromAmount)! <= 0 ? 0.5 : 1.0)
    }
    
    // MARK: - Helper Functions
    private func calculateToAmount() {
        guard let fromToken = currentFromToken,
              let toToken = currentToToken,
              let amount = Double(fromAmount),
              amount > 0 else {
            toAmount = ""
            exchangeRate = 0
            return
        }
        
        // Calculate exchange rate using live prices: how many toToken units per 1 fromToken unit
        // Example: 1 SOL = 150.29 EUR, 1 BTC = 43250 EUR
        // Rate: 150.29 / 43250 = 0.00347 BTC per SOL
        let rate = fromToken.price / toToken.price
        exchangeRate = rate
        
        // Calculate result: amount * rate
        // Example: 50 SOL * 0.00347 = 0.1735 BTC
        let result = amount * rate
        
        // Format based on token value - more decimals for smaller values
        if result < 0.01 {
            toAmount = String(format: "%.8f", result)
        } else if result < 1 {
            toAmount = String(format: "%.6f", result)
        } else if result < 100 {
            toAmount = String(format: "%.4f", result)
        } else {
            toAmount = String(format: "%.2f", result)
        }
        
        // Remove trailing zeros
        if let doubleValue = Double(toAmount) {
            if doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
                toAmount = String(format: "%.0f", doubleValue)
            } else {
                // Remove trailing zeros using NumberFormatter
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 0
                formatter.maximumFractionDigits = 8
                formatter.numberStyle = .decimal
                if let number = formatter.number(from: toAmount) {
                    toAmount = formatter.string(from: number) ?? toAmount
                }
            }
        }
    }
    
    private func swapTokens() {
        guard let currentFrom = fromToken, let currentTo = toToken else { return }
        
        // Swap token references (keep the updated versions from allTokens)
        if let updatedFrom = appState.allTokens.first(where: { $0.symbol == currentTo.symbol }),
           let updatedTo = appState.allTokens.first(where: { $0.symbol == currentFrom.symbol }) {
            fromToken = updatedFrom
            toToken = updatedTo
        }
        
        let tempAmount = fromAmount
        fromAmount = toAmount
        toAmount = tempAmount
    }
    
    private func formatRate(_ rate: Double) -> String {
        if rate < 0.0001 {
            return String(format: "%.8f", rate)
        } else if rate < 0.01 {
            return String(format: "%.6f", rate)
        } else if rate < 1 {
            return String(format: "%.4f", rate)
        } else {
            return String(format: "%.2f", rate)
        }
    }
}

// MARK: - Token Selection View
struct TokenSelectionView: View {
    @Binding var isPresented: Bool
    @Binding var selectedToken: Token
    let availableTokens: [Token]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Select Token")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            
            // Token List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(availableTokens) { token in
                        Button {
                            selectedToken = token
                            HapticManager.shared.selection()
                            isPresented = false
                        } label: {
                            TokenSelectionRow(token: token, isSelected: token.id == selectedToken.id)
                        }
                        .buttonStyle(.plain)
                        
                        if token.id != availableTokens.last?.id {
                            Divider()
                                .padding(.leading, 60)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(
            ZStack {
                Color.deepDark.ignoresSafeArea()
                RoundedRectangle(cornerRadius: 0)
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
        )
        .presentationDetents([.fraction(0.7)])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Token Selection Row
struct TokenSelectionRow: View {
    let token: Token
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(token.color.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: token.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(token.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(token.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("\(String(format: "%.2f", token.balance)) \(token.symbol)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.phantomPurple)
            }
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

// MARK: - Swap Confirmation View
struct SwapConfirmationView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var appState: AppStateManager
    let fromToken: Token
    let toToken: Token
    let fromAmount: String
    let toAmount: String
    
    @State private var isProcessing = false
    @State private var showSuccess = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "arrow.left.arrow.right.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.phantomPurple, Color.phantomGold],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Confirm Swap")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            .padding(.top, 8)
            
            // Swap Details
            VStack(spacing: 16) {
                swapDetailRow(title: "From", amount: fromAmount, token: fromToken.symbol)
                swapDetailRow(title: "To", amount: toAmount, token: toToken.symbol)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
            
            // Action Buttons
            VStack(spacing: 12) {
                Button {
                    executeSwap()
                } label: {
                    HStack(spacing: 8) {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else if showSuccess {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18, weight: .medium))
                        } else {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .medium))
                            Text("Confirm Swap")
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.phantomPurple.opacity(0.85))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                            )
                    )
                    .shadow(color: Color.phantomPurple.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(.plain)
                .disabled(isProcessing || showSuccess)
                
                Button {
                    HapticManager.shared.selection()
                    isPresented = false
                } label: {
                    Text("Cancel")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.phantomPurple)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .buttonStyle(.plain)
            }
            
            Spacer(minLength: 0)
        }
        .padding()
        .background(
            ZStack {
                Color.deepDark.ignoresSafeArea()
                RoundedRectangle(cornerRadius: 0)
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
        )
        .presentationDetents([.fraction(0.6)])
        .presentationDragIndicator(.visible)
    }
    
    private func swapDetailRow(title: String, amount: String, token: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text("\(amount) \(token)")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
    }
    
    private func executeSwap() {
        guard let fromAmountValue = Double(fromAmount),
              let toAmountValue = Double(toAmount),
              fromAmountValue > 0,
              toAmountValue > 0 else {
            return
        }
        
        isProcessing = true
        HapticManager.shared.impact(.medium)
        
        appState.swapTokens(
            fromToken: fromToken,
            toToken: toToken,
            fromAmount: fromAmountValue,
            toAmount: toAmountValue
        ) { success in
            isProcessing = false
            if success {
                showSuccess = true
                HapticManager.shared.notification(.success)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isPresented = false
                }
            } else {
                HapticManager.shared.notification(.error)
            }
        }
    }
}

