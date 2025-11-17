//
//  SendView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Send View
struct SendView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var appState: AppStateManager
    @State private var recipientAddress: String = ""
    @State private var amount: String = ""
    @State private var selectedToken: Token = Token.topCryptocurrencies.first!
    @State private var isScanningQR = false
    @State private var isSending = false
    @State private var showSuccess = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Send")
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
            
            // Token Selection
            tokenSelection
            
            // Amount Input
            amountInput
            
            // Recipient Address
            recipientInput
            
            // Transaction Fee
            transactionFee
            
            // Send Button
            sendButton
            
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
        .presentationDetents([.fraction(0.85)])
        .presentationDragIndicator(.visible)
    }
    
    private var tokenSelection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Token")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            HStack {
                ZStack {
                    Circle()
                        .fill(selectedToken.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: selectedToken.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(selectedToken.color)
                }
                
                Text(selectedToken.symbol)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text("Balance: \(String(format: "%.2f", selectedToken.balance))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    private var amountInput: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Amount")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            HStack {
                TextField("0.0", text: $amount)
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                    .foregroundStyle(.primary)
                    .keyboardType(.decimalPad)
                
                Spacer()
                
                Button("Max") {
                    amount = String(format: "%.2f", selectedToken.balance)
                    HapticManager.shared.selection()
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.phantomPurple)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    private var recipientInput: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Recipient Address")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button {
                    isScanningQR = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.title3)
                        .foregroundColor(.phantomPurple)
                }
            }
            
            TextField("Enter address...", text: $recipientAddress)
                .font(.system(size: 16, design: .monospaced))
                .foregroundStyle(.primary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                )
        }
        .sheet(isPresented: $isScanningQR) {
            QRScannerView(isPresented: $isScanningQR, scannedAddress: $recipientAddress)
        }
    }
    
    private var transactionFee: some View {
        HStack {
            Text("Transaction Fee")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text("~0.000005 SOL")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    private var sendButton: some View {
        Button {
            sendTransaction()
        } label: {
            HStack {
                if isSending {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else if showSuccess {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                } else {
                    Text("Send")
                        .font(.body)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [Color.phantomPurple, Color.phantomGold],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
        }
        .buttonStyle(.plain)
        .disabled(amount.isEmpty || recipientAddress.isEmpty || Double(amount) == nil || isSending || showSuccess)
        .opacity(amount.isEmpty || recipientAddress.isEmpty || Double(amount) == nil || isSending || showSuccess ? 0.6 : 1.0)
    }
    
    private func sendTransaction() {
        guard let amountValue = Double(amount),
              amountValue > 0,
              amountValue <= selectedToken.balance else {
            return
        }
        
        isSending = true
        HapticManager.shared.impact(.medium)
        
        appState.sendTransaction(
            fromToken: selectedToken,
            amount: amountValue,
            recipientAddress: recipientAddress
        ) { success in
            isSending = false
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

// MARK: - QR Scanner View (Placeholder)
struct QRScannerView: View {
    @Binding var isPresented: Bool
    @Binding var scannedAddress: String
    
    var body: some View {
        VStack(spacing: 24) {
            Text("QR Code Scanner")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Scan QR code to get address")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Placeholder for QR scanner
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 250, height: 250)
                
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 64))
                    .foregroundStyle(.tertiary)
            }
            
            Button {
                // Simulate scanning
                scannedAddress = "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU"
                isPresented = false
            } label: {
                Text("Use Demo Address")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.phantomPurple, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            
            Button {
                isPresented = false
            } label: {
                Text("Cancel")
                    .font(.body)
                    .foregroundColor(.phantomPurple)
            }
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
        .presentationDetents([.fraction(0.7)])
    }
}

