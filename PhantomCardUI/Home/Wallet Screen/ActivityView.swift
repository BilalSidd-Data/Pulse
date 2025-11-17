//
//  ActivityView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Activity View
struct ActivityView: View {
    @EnvironmentObject private var appState: AppStateManager
    @State private var selectedFilter: ActivityFilter = .all
    @State private var searchText: String = ""
    @State private var selectedTransaction: TransactionData?
    @State private var showTransactionDetail = false
    @State private var isExportSheetPresented = false
    
    enum ActivityFilter: String, CaseIterable {
        case all = "All"
        case sent = "Sent"
        case received = "Received"
        case swapped = "Swapped"
        case card = "Card"
    }
    
    private var filteredTransactions: [TransactionData] {
        let transactions = appState.transactions
        
        let filtered = transactions.filter { transaction in
            if !searchText.isEmpty {
                return transaction.merchant.localizedCaseInsensitiveContains(searchText)
            }
            return true
        }
        
        switch selectedFilter {
        case .all:
            return filtered
        case .sent:
            return filtered.filter { !$0.isCredit }
        case .received:
            return filtered.filter { $0.isCredit }
        case .swapped:
            return filtered.filter { $0.category == "Swap" }
        case .card:
            return filtered.filter { $0.category != "Swap" && $0.category != "Deposit" }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                HeaderView(
                    onAddTapped: {},
                    onNotificationsTapped: {},
                    hasUnreadNotifications: appState.notifications.contains { !$0.isRead },
                    onSettingsTapped: nil
                )
                
                Spacer()
                
                // Export Button
                Button {
                    isExportSheetPresented = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.phantomPurple)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            // Search Bar
            searchBar
            
            // Filter Chips
            filterChips
            
            // Transaction List
            transactionList
        }
        .background(Color.deepDark.edgesIgnoringSafeArea(.all))
        .refreshable {
            appState.refreshData()
        }
        .sheet(item: $selectedTransaction) { transaction in
            TransactionDetailView(isPresented: $showTransactionDetail, transaction: transaction)
        }
        .sheet(isPresented: $isExportSheetPresented) {
            TransactionExportView(isPresented: $isExportSheetPresented, transactions: appState.transactions)
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.6))
            
            TextField("Search transactions...", text: $searchText)
                .foregroundColor(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    // MARK: - Filter Chips
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ActivityFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    ) {
                        HapticManager.shared.selection()
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Transaction List
    private var transactionList: some View {
        ScrollView {
            if filteredTransactions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundStyle(.tertiary)
                    
                    Text("No Transactions Found")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    
                    Text("Try adjusting your filters")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(filteredTransactions) { transaction in
                        TransactionRowWithActions(
                            transaction: transaction,
                            onTap: {
                                selectedTransaction = transaction
                                showTransactionDetail = true
                            },
                            onDelete: {
                                appState.deleteTransaction(transaction)
                            }
                        )
                        
                        if transaction.id != filteredTransactions.last?.id {
                            Divider()
                                .padding(.leading, 60)
                        }
                    }
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
                .padding(.horizontal, 24)
                .padding(.bottom, 120)
            }
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.phantomPurple : Color.white.opacity(0.1))
                )
        }
    }
}

