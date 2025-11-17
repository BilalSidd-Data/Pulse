//
//  HomeView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Home View
struct HomeView: View {
    @EnvironmentObject private var tabSelection: TabSelectionManager
    @EnvironmentObject private var appState: AppStateManager
    @State private var isSendSheetPresented = false
    @State private var isReceiveSheetPresented = false
    @State private var isAddTokenSheetPresented = false
    @State private var isSettingsPresented = false
    @State private var isNotificationsPresented = false
    @State private var isPortfolioAnalyticsPresented = false
    @State private var isExportSheetPresented = false
    @State private var selectedTokenForChart: Token?
    @State private var showTokenChart = false
    
    private var tokens: [Token] {
        appState.tokens
    }
    
    private var allTokens: [Token] {
        appState.allTokens
    }
    
    private func handleNotificationsTapped() {
        isNotificationsPresented = true
    }
    
    // Cached computed properties for better performance
    @State private var cachedPortfolioValue: Double = 0
    @State private var cachedPortfolioChange: Double = 0
    
    private var totalPortfolioValue: Double {
        cachedPortfolioValue
    }
    
    private var portfolioChange24h: Double {
        cachedPortfolioChange
    }
    
    private func updateCachedValues() {
        let total = tokens.reduce(0) { $0 + $1.balanceInUSD }
        cachedPortfolioValue = total
        
        guard total > 0 else {
            cachedPortfolioChange = 0
            return
        }
        
        let weightedChange = tokens.reduce(0) { sum, token in
            sum + (token.balanceInUSD / total) * token.change24h
        }
        cachedPortfolioChange = weightedChange
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HeaderView(
                    onAddTapped: {
                        isAddTokenSheetPresented = true
                    },
                    onNotificationsTapped: handleNotificationsTapped,
                    hasUnreadNotifications: false,
                    onSettingsTapped: {
                        isSettingsPresented = true
                    }
                )
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Portfolio Overview
                Button {
                    isPortfolioAnalyticsPresented = true
                } label: {
                    portfolioOverview
                }
                .buttonStyle(.plain)
                
                // Quick Actions
                quickActions
                
                // Token List
                tokenList
                
                // Recent Activity Preview
                recentActivityPreview
                
                Spacer(minLength: 120)
            }
            .padding(.top, 8)
            .padding(.horizontal, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .scrollIndicators(.hidden)
        .background(Color.deepDark.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isSendSheetPresented) {
            SendView(isPresented: $isSendSheetPresented)
        }
        .sheet(isPresented: $isReceiveSheetPresented) {
            ReceiveView(isPresented: $isReceiveSheetPresented)
        }
        .sheet(isPresented: $isAddTokenSheetPresented) {
            AddTokenView(isPresented: $isAddTokenSheetPresented, tokens: $appState.tokens, allTokens: allTokens)
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsView()
        }
        .sheet(isPresented: $isNotificationsPresented) {
            NotificationsSheet(isPresented: $isNotificationsPresented, notifications: $appState.notifications)
        }
        .sheet(isPresented: $isPortfolioAnalyticsPresented) {
            PortfolioAnalyticsView()
        }
        .sheet(isPresented: $isExportSheetPresented) {
            TransactionExportView(isPresented: $isExportSheetPresented, transactions: appState.transactions)
        }
        .sheet(item: $selectedTokenForChart) { token in
            TokenPriceChartView(token: token)
        }
        .refreshable {
            appState.refreshData()
        }
        .onAppear {
            updateCachedValues()
        }
        .onChange(of: tokens) { _, _ in
            updateCachedValues()
        }
    }
    
    // MARK: - Portfolio Overview
    private var portfolioOverview: some View {
        VStack(spacing: 16) {
            Text("Total Portfolio Value")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            Text(CurrencyFormatter.shared.formatWithSymbol(totalPortfolioValue))
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.white, Color.phantomPurple.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            HStack(spacing: 8) {
                Image(systemName: portfolioChange24h >= 0 ? "arrow.up.right" : "arrow.down.right")
                    .font(.caption)
                    .foregroundColor(portfolioChange24h >= 0 ? .green : .red)
                
                Text("\(portfolioChange24h >= 0 ? "+" : "")\(String(format: "%.2f", portfolioChange24h))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(portfolioChange24h >= 0 ? .green : .red)
                
                Text("24h")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
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
    
    // MARK: - Quick Actions
    private var quickActions: some View {
        HStack(spacing: 16) {
            QuickActionButton(
                icon: "arrow.up.circle.fill",
                title: "Send",
                color: .phantomPurple
            ) {
                isSendSheetPresented = true
            }
            
            QuickActionButton(
                icon: "arrow.down.circle.fill",
                title: "Receive",
                color: .green
            ) {
                isReceiveSheetPresented = true
            }
            
            QuickActionButton(
                icon: "arrow.left.arrow.right.circle.fill",
                title: "Swap",
                color: .phantomGold
            ) {
                tabSelection.selectedTab = TabItem.swap
            }
            
            QuickActionButton(
                icon: "plus.circle.fill",
                title: "Add",
                color: .blue
            ) {
                isAddTokenSheetPresented = true
            }
        }
    }
    
    // MARK: - Token List
    private var tokenList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Assets")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVStack(spacing: 0) {
                ForEach(tokens) { token in
                    TokenRowWithActions(
                        token: token,
                        onChartTap: {
                            selectedTokenForChart = token
                        }
                    )
                    
                    if token.id != tokens.last?.id {
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
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
    
    // MARK: - Recent Activity Preview
    private var recentActivityPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Activity")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        isExportSheetPresented = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.callout)
                            .foregroundColor(.phantomPurple)
                    }
                    
                    Button(action: {
                        tabSelection.selectedTab = .activity
                    }) {
                        Text("See All")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.phantomPurple)
                    }
                }
            }
            
            // Show last 3 transactions
            LazyVStack(spacing: 0) {
                ForEach(Array(appState.transactions.prefix(3))) { transaction in
                    Button {
                        // Navigate to activity tab to see details
                        tabSelection.selectedTab = .activity
                    } label: {
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
                    
                    if transaction.id != appState.transactions.prefix(3).last?.id {
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
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
    
}

// MARK: - Token Row
struct TokenRow: View {
    let token: Token
    
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
                Text("$\(String(format: "%.2f", token.balanceInUSD))")
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
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.shared.selection()
            action()
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Transaction Data
struct TransactionData: Identifiable {
    let id = UUID()
    let icon: String
    let merchant: String
    let date: String
    let amount: String
    let eurAmount: String
    let isCredit: Bool
    let category: String
    var tokenSymbol: String = "SOL"
    var tokenAmount: Double = 0
}

