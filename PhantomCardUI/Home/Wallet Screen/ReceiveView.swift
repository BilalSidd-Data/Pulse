//
//  ReceiveView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Receive View
struct ReceiveView: View {
    @Binding var isPresented: Bool
    @State private var selectedToken: Token = Token(
        symbol: "SOL",
        name: "Solana",
        balance: 25.5,
        balanceInUSD: 3825.75,
        price: 150.29,
        change24h: 2.45,
        icon: "sun.max.fill",
        color: .purple
    )
    
    private let walletAddress = "7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU"
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Receive")
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
            
            // QR Code
            qrCodeView
            
            // Address
            addressView
            
            // Action Buttons
            actionButtons
            
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
            Text("Receive")
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
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    private var qrCodeView: some View {
        VStack(spacing: 16) {
            // QR Code Placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: 250, height: 250)
                
                // Simple QR pattern (placeholder)
                VStack(spacing: 4) {
                    ForEach(0..<20) { _ in
                        HStack(spacing: 4) {
                            ForEach(0..<20) { _ in
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
    }
    
    private var addressView: some View {
        VStack(spacing: 12) {
            Text("Your Address")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                Text(walletAddress)
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                Button {
                    UIPasteboard.general.string = walletAddress
                    HapticManager.shared.notification(.success)
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.title3)
                        .foregroundColor(.phantomPurple)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                UIPasteboard.general.string = walletAddress
                HapticManager.shared.notification(.success)
            } label: {
                HStack {
                    Image(systemName: "doc.on.doc")
                    Text("Copy Address")
                }
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.phantomPurple, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            
            Button {
                // Share functionality
                HapticManager.shared.selection()
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.phantomPurple)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.phantomPurple, lineWidth: 1.5)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

