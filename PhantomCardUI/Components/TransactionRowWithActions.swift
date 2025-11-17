//
//  TransactionRowWithActions.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Transaction Row With Actions
struct TransactionRowWithActions: View {
    let transaction: TransactionData
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var showDetail = false
    
    var body: some View {
        Button(action: {
            HapticManager.shared.selection()
            showDetail = true
        }) {
            TransactionRow(
                icon: transaction.icon,
                merchant: transaction.merchant,
                date: transaction.date,
                amount: transaction.amount,
                eurAmount: transaction.eurAmount,
                isCredit: transaction.isCredit,
                category: transaction.category
            )
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                HapticManager.shared.impact(.medium)
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showDetail) {
            TransactionDetailView(isPresented: $showDetail, transaction: transaction)
        }
    }
}

