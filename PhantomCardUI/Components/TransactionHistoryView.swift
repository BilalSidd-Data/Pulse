//
//  TransactionHistoryView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Transaction Row
struct TransactionRow: View {
    let icon: String
    let merchant: String
    let date: String
    let amount: String
    let eurAmount: String?
    let isCredit: Bool
    let category: String?
    
    init(
        icon: String,
        merchant: String,
        date: String,
        amount: String,
        eurAmount: String? = nil,
        isCredit: Bool,
        category: String? = nil
    ) {
        self.icon = icon
        self.merchant = merchant
        self.date = date
        self.amount = amount
        self.eurAmount = eurAmount
        self.isCredit = isCredit
        self.category = category
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Enhanced Icon with gradient
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isCredit ?
                                [Color.green.opacity(0.2), Color.green.opacity(0.1)] :
                                [Color.phantomPurple.opacity(0.2), Color.phantomPurple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: isCredit ?
                                [Color.green, Color.green.opacity(0.8)] :
                                [Color.phantomPurple, Color.phantomGold],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(merchant)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    if let category = category {
                        Text(category)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                }
                
                HStack(spacing: 8) {
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                    
                    if let eurAmount = eurAmount {
                        Text("•")
                            .foregroundColor(.white.opacity(0.3))
                        Text(eurAmount)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            
            Spacer()
            
            // Enhanced Amount display
            VStack(alignment: .trailing, spacing: 4) {
                Text(amount)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundStyle(
                        LinearGradient(
                            colors: isCredit ?
                                [Color.green, Color.green.opacity(0.8)] :
                                [Color.white, Color.white.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                if let eurAmount = eurAmount {
                    Text(eurAmount)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

// MARK: - Transaction History View
struct TransactionHistoryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with iOS 18 style
            HStack {
                Text("Recent Activity")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button(action: {
                    HapticManager.shared.selection()
                }) {
                    Text("See All")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.phantomPurple)
                }
            }
            .padding(.horizontal)
            
            // Transaction List with enhanced styling
            VStack(spacing: 0) {
                TransactionRow(
                    icon: "bag.fill",
                    merchant: "Amazon Inc.",
                    date: "Today, 2:30 PM",
                    amount: "-4.5 SOL",
                    eurAmount: "€675.00",
                    isCredit: false,
                    category: "Shopping"
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.leading, 60)
                
                TransactionRow(
                    icon: "arrow.down.circle.fill",
                    merchant: "Deposit (ETH Bridge)",
                    date: "Yesterday, 10:15 AM",
                    amount: "+25.0 SOL",
                    eurAmount: "€3,750.00",
                    isCredit: true,
                    category: "Deposit"
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.leading, 60)
                
                TransactionRow(
                    icon: "fork.knife",
                    merchant: "Sushi Restaurant",
                    date: "Oct 31, 8:45 PM",
                    amount: "-0.8 SOL",
                    eurAmount: "€120.00",
                    isCredit: false,
                    category: "Dining"
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.leading, 60)
                
                TransactionRow(
                    icon: "fuelpump.fill",
                    merchant: "Shell Gas Station",
                    date: "Oct 30, 3:20 PM",
                    amount: "-1.2 SOL",
                    eurAmount: "€180.00",
                    isCredit: false,
                    category: "Fuel"
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
        .padding(.top, 24)
    }
}

// MARK: - Preview
struct TransactionHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionHistoryView()
            .padding()
            .background(Color.deepDark)
            .preferredColorScheme(.dark)
    }
}
