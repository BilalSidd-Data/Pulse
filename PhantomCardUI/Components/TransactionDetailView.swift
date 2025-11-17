//
//  TransactionDetailView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Transaction Detail View
struct TransactionDetailView: View {
    @Binding var isPresented: Bool
    let transaction: TransactionData
    @EnvironmentObject private var appState: AppStateManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Transaction Icon
                    transactionIcon
                    
                    // Amount Display
                    amountDisplay
                    
                    // Transaction Details
                    transactionDetails
                    
                    // Status Section
                    statusSection
                    
                    // Additional Info
                    additionalInfo
                }
                .padding()
            }
            .background(Color.deepDark.ignoresSafeArea())
            .navigationTitle("Transaction Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Transaction Icon
    private var transactionIcon: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: transaction.isCredit ? 
                            [Color.green.opacity(0.3), Color.green.opacity(0.1)] :
                            [Color.phantomPurple.opacity(0.3), Color.phantomPurple.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
            
            Image(systemName: transaction.icon)
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(transaction.isCredit ? .green : .phantomPurple)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Amount Display
    private var amountDisplay: some View {
        VStack(spacing: 8) {
            Text(transaction.amount)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(transaction.isCredit ? .green : .white)
            
            Text(transaction.eurAmount)
                .font(.title3)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    // MARK: - Transaction Details
    private var transactionDetails: some View {
        VStack(spacing: 16) {
            DetailRow(label: "Merchant", value: transaction.merchant)
            DetailRow(label: "Category", value: transaction.category)
            DetailRow(label: "Date", value: transaction.date)
            DetailRow(label: "Type", value: transaction.isCredit ? "Received" : "Sent")
            DetailRow(label: "Token", value: transaction.tokenSymbol)
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
    }
    
    // MARK: - Status Section
    private var statusSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                
                Text("Completed")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.1))
            )
        }
    }
    
    // MARK: - Additional Info
    private var additionalInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Transaction Information")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                InfoRow(icon: "clock.fill", text: "Transaction completed successfully")
                InfoRow(icon: "network", text: "Network: Solana Mainnet")
                InfoRow(icon: "shield.checkered", text: "Verified on blockchain")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
}

// MARK: - Detail Row
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.phantomPurple)
                .frame(width: 20)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
        }
    }
}

