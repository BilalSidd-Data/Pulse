//
//  AppStateManager.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI
import Combine

// MARK: - App State Manager
class AppStateManager: ObservableObject {
    static let shared = AppStateManager()
    
    // MARK: - Published Properties
    @Published var tokens: [Token] = Token.topCryptocurrencies.filter { $0.balance > 0 }
    @Published var allTokens: [Token] = Token.topCryptocurrencies
    @Published var transactions: [TransactionData] = []
    @Published var notifications: [NotificationItem] = []
    @Published var isRefreshing: Bool = false
    @Published var favoriteTokenIds: Set<UUID> = []
    
    // MARK: - Private Properties
    private var priceUpdateTimer: Timer?
    private let priceService = PriceService.shared
    
    // MARK: - Initialization
    private init() {
        loadInitialData()
        startPriceUpdates()
        // Fetch initial prices immediately
        Task {
            await fetchRealTimePrices()
        }
    }
    
    // MARK: - Data Loading
    private func loadInitialData() {
        // Load initial transactions - comprehensive realistic data
        let now = Date()
        transactions = [
            // Today's transactions
            TransactionData(
                icon: "bag.fill",
                merchant: "Amazon Inc.",
                date: formatDate(now.addingTimeInterval(-3600)),
                amount: "-12.5 SOL",
                eurAmount: "€1,878.63",
                isCredit: false,
                category: "Shopping",
                tokenSymbol: "SOL",
                tokenAmount: -12.5
            ),
            TransactionData(
                icon: "arrow.left.arrow.right",
                merchant: "Swap SOL → BTC",
                date: formatDate(now.addingTimeInterval(-7200)),
                amount: "-50.0 SOL",
                eurAmount: "+0.173 BTC",
                isCredit: false,
                category: "Swap",
                tokenSymbol: "SOL",
                tokenAmount: -50.0
            ),
            TransactionData(
                icon: "diamond.fill",
                merchant: "ETH Staking Reward",
                date: formatDate(now.addingTimeInterval(-10800)),
                amount: "+0.15 ETH",
                eurAmount: "€397.50",
                isCredit: true,
                category: "Staking",
                tokenSymbol: "ETH",
                tokenAmount: 0.15
            ),
            TransactionData(
                icon: "fork.knife",
                merchant: "Nobu Restaurant",
                date: formatDate(now.addingTimeInterval(-14400)),
                amount: "-2.5 SOL",
                eurAmount: "€375.73",
                isCredit: false,
                category: "Dining",
                tokenSymbol: "SOL",
                tokenAmount: -2.5
            ),
            TransactionData(
                icon: "arrow.down.circle.fill",
                merchant: "Deposit from Exchange",
                date: formatDate(now.addingTimeInterval(-18000)),
                amount: "+100.0 SOL",
                eurAmount: "€15,029.00",
                isCredit: true,
                category: "Deposit",
                tokenSymbol: "SOL",
                tokenAmount: 100.0
            ),
            
            // Yesterday's transactions
            TransactionData(
                icon: "fuelpump.fill",
                merchant: "Shell Gas Station",
                date: formatDate(now.addingTimeInterval(-86400 - 3600)),
                amount: "-1.2 SOL",
                eurAmount: "€180.35",
                isCredit: false,
                category: "Fuel",
                tokenSymbol: "SOL",
                tokenAmount: -1.2
            ),
            TransactionData(
                icon: "bitcoinsign.circle.fill",
                merchant: "BTC Purchase",
                date: formatDate(now.addingTimeInterval(-86400 - 7200)),
                amount: "-0.5 BTC",
                eurAmount: "€21,625.00",
                isCredit: false,
                category: "Purchase",
                tokenSymbol: "BTC",
                tokenAmount: -0.5
            ),
            TransactionData(
                icon: "arrow.up.circle.fill",
                merchant: "Sent to Wallet",
                date: formatDate(now.addingTimeInterval(-86400 - 10800)),
                amount: "-5.0 ETH",
                eurAmount: "€13,250.00",
                isCredit: false,
                category: "Transfer",
                tokenSymbol: "ETH",
                tokenAmount: -5.0
            ),
            TransactionData(
                icon: "gift.fill",
                merchant: "Airdrop Received",
                date: formatDate(now.addingTimeInterval(-86400 - 14400)),
                amount: "+500 USDC",
                eurAmount: "€500.00",
                isCredit: true,
                category: "Airdrop",
                tokenSymbol: "USDC",
                tokenAmount: 500.0
            ),
            TransactionData(
                icon: "cart.fill",
                merchant: "Apple Store",
                date: formatDate(now.addingTimeInterval(-86400 - 18000)),
                amount: "-8.0 SOL",
                eurAmount: "€1,202.32",
                isCredit: false,
                category: "Shopping",
                tokenSymbol: "SOL",
                tokenAmount: -8.0
            ),
            
            // 2 days ago
            TransactionData(
                icon: "arrow.left.arrow.right",
                merchant: "Swap BTC → ETH",
                date: formatDate(now.addingTimeInterval(-172800)),
                amount: "-0.2 BTC",
                eurAmount: "+3.26 ETH",
                isCredit: false,
                category: "Swap",
                tokenSymbol: "BTC",
                tokenAmount: -0.2
            ),
            TransactionData(
                icon: "bed.double.fill",
                merchant: "Marriott Hotel",
                date: formatDate(now.addingTimeInterval(-172800 - 3600)),
                amount: "-25.0 SOL",
                eurAmount: "€3,757.25",
                isCredit: false,
                category: "Travel",
                tokenSymbol: "SOL",
                tokenAmount: -25.0
            ),
            TransactionData(
                icon: "diamond.fill",
                merchant: "ETH Staking Reward",
                date: formatDate(now.addingTimeInterval(-172800 - 7200)),
                amount: "+0.12 ETH",
                eurAmount: "€318.00",
                isCredit: true,
                category: "Staking",
                tokenSymbol: "ETH",
                tokenAmount: 0.12
            ),
            TransactionData(
                icon: "gamecontroller.fill",
                merchant: "Steam Purchase",
                date: formatDate(now.addingTimeInterval(-172800 - 10800)),
                amount: "-1.5 SOL",
                eurAmount: "€225.44",
                isCredit: false,
                category: "Entertainment",
                tokenSymbol: "SOL",
                tokenAmount: -1.5
            ),
            
            // 3 days ago
            TransactionData(
                icon: "arrow.down.circle.fill",
                merchant: "Received from Wallet",
                date: formatDate(now.addingTimeInterval(-259200)),
                amount: "+200.0 SOL",
                eurAmount: "€30,058.00",
                isCredit: true,
                category: "Deposit",
                tokenSymbol: "SOL",
                tokenAmount: 200.0
            ),
            TransactionData(
                icon: "creditcard.fill",
                merchant: "Card Payment - Uber",
                date: formatDate(now.addingTimeInterval(-259200 - 3600)),
                amount: "-0.5 SOL",
                eurAmount: "€75.15",
                isCredit: false,
                category: "Transport",
                tokenSymbol: "SOL",
                tokenAmount: -0.5
            ),
            TransactionData(
                icon: "bitcoinsign.circle.fill",
                merchant: "BTC Mining Reward",
                date: formatDate(now.addingTimeInterval(-259200 - 7200)),
                amount: "+0.001 BTC",
                eurAmount: "€43.25",
                isCredit: true,
                category: "Mining",
                tokenSymbol: "BTC",
                tokenAmount: 0.001
            ),
            TransactionData(
                icon: "arrow.left.arrow.right",
                merchant: "Swap ETH → SOL",
                date: formatDate(now.addingTimeInterval(-259200 - 10800)),
                amount: "-10.0 ETH",
                eurAmount: "+176.4 SOL",
                isCredit: false,
                category: "Swap",
                tokenSymbol: "ETH",
                tokenAmount: -10.0
            ),
            
            // 4 days ago
            TransactionData(
                icon: "cup.and.saucer.fill",
                merchant: "Starbucks",
                date: formatDate(now.addingTimeInterval(-345600)),
                amount: "-0.3 SOL",
                eurAmount: "€45.09",
                isCredit: false,
                category: "Dining",
                tokenSymbol: "SOL",
                tokenAmount: -0.3
            ),
            TransactionData(
                icon: "film.fill",
                merchant: "Netflix Subscription",
                date: formatDate(now.addingTimeInterval(-345600 - 3600)),
                amount: "-0.2 SOL",
                eurAmount: "€30.06",
                isCredit: false,
                category: "Subscription",
                tokenSymbol: "SOL",
                tokenAmount: -0.2
            ),
            TransactionData(
                icon: "arrow.down.circle.fill",
                merchant: "Deposit (Binance)",
                date: formatDate(now.addingTimeInterval(-345600 - 7200)),
                amount: "+50.0 BNB",
                eurAmount: "€15,775.00",
                isCredit: true,
                category: "Deposit",
                tokenSymbol: "BNB",
                tokenAmount: 50.0
            ),
            
            // 5 days ago
            TransactionData(
                icon: "airplane.departure",
                merchant: "Lufthansa Airlines",
                date: formatDate(now.addingTimeInterval(-432000)),
                amount: "-150.0 SOL",
                eurAmount: "€22,543.50",
                isCredit: false,
                category: "Travel",
                tokenSymbol: "SOL",
                tokenAmount: -150.0
            ),
            TransactionData(
                icon: "arrow.left.arrow.right",
                merchant: "Swap USDC → BTC",
                date: formatDate(now.addingTimeInterval(-432000 - 3600)),
                amount: "-10,000 USDC",
                eurAmount: "+0.231 BTC",
                isCredit: false,
                category: "Swap",
                tokenSymbol: "USDC",
                tokenAmount: -10000.0
            ),
            TransactionData(
                icon: "diamond.fill",
                merchant: "ETH Staking Reward",
                date: formatDate(now.addingTimeInterval(-432000 - 7200)),
                amount: "+0.18 ETH",
                eurAmount: "€477.00",
                isCredit: true,
                category: "Staking",
                tokenSymbol: "ETH",
                tokenAmount: 0.18
            ),
            
            // 6 days ago
            TransactionData(
                icon: "cart.fill",
                merchant: "Best Buy",
                date: formatDate(now.addingTimeInterval(-518400)),
                amount: "-6.5 SOL",
                eurAmount: "€976.89",
                isCredit: false,
                category: "Shopping",
                tokenSymbol: "SOL",
                tokenAmount: -6.5
            ),
            TransactionData(
                icon: "arrow.down.circle.fill",
                merchant: "Received from Wallet",
                date: formatDate(now.addingTimeInterval(-518400 - 3600)),
                amount: "+1.5 BTC",
                eurAmount: "€64,875.00",
                isCredit: true,
                category: "Deposit",
                tokenSymbol: "BTC",
                tokenAmount: 1.5
            ),
            TransactionData(
                icon: "snowflake",
                merchant: "AVAX Staking Reward",
                date: formatDate(now.addingTimeInterval(-518400 - 7200)),
                amount: "+5.0 AVAX",
                eurAmount: "€192.50",
                isCredit: true,
                category: "Staking",
                tokenSymbol: "AVAX",
                tokenAmount: 5.0
            ),
            
            // 7 days ago
            TransactionData(
                icon: "fork.knife",
                merchant: "The French Laundry",
                date: formatDate(now.addingTimeInterval(-604800)),
                amount: "-5.0 SOL",
                eurAmount: "€751.45",
                isCredit: false,
                category: "Dining",
                tokenSymbol: "SOL",
                tokenAmount: -5.0
            ),
            TransactionData(
                icon: "arrow.left.arrow.right",
                merchant: "Swap BTC → SOL",
                date: formatDate(now.addingTimeInterval(-604800 - 3600)),
                amount: "-0.1 BTC",
                eurAmount: "+28.8 SOL",
                isCredit: false,
                category: "Swap",
                tokenSymbol: "BTC",
                tokenAmount: -0.1
            ),
            TransactionData(
                icon: "gift.fill",
                merchant: "NFT Purchase",
                date: formatDate(now.addingTimeInterval(-604800 - 7200)),
                amount: "-2.0 ETH",
                eurAmount: "€5,300.00",
                isCredit: false,
                category: "NFT",
                tokenSymbol: "ETH",
                tokenAmount: -2.0
            )
        ]
        
        // Load comprehensive notifications
        notifications = [
            NotificationItem(
                title: "Transaction Completed",
                message: "Payment of €1,878.63 to Amazon Inc. was successful",
                time: "1 hour ago",
                icon: "checkmark.circle.fill",
                isRead: false,
                type: .transaction
            ),
            NotificationItem(
                title: "Swap Executed",
                message: "Successfully swapped 50.0 SOL for 0.173 BTC",
                time: "2 hours ago",
                icon: "arrow.left.arrow.right.circle.fill",
                isRead: false,
                type: .transaction
            ),
            NotificationItem(
                title: "Staking Reward Received",
                message: "You received 0.15 ETH (€397.50) from staking",
                time: "3 hours ago",
                icon: "diamond.fill",
                isRead: false,
                type: .transaction
            ),
            NotificationItem(
                title: "Daily Limit Reached",
                message: "You've used 85% of your daily spending limit",
                time: "5 hours ago",
                icon: "exclamationmark.triangle.fill",
                isRead: false,
                type: .limit
            ),
            NotificationItem(
                title: "Large Transaction Alert",
                message: "Transaction of €21,625.00 detected",
                time: "Yesterday",
                icon: "bell.fill",
                isRead: false,
                type: .security
            ),
            NotificationItem(
                title: "Price Alert: BTC",
                message: "Bitcoin price increased by 2.34% in the last 24h",
                time: "Yesterday",
                icon: "chart.line.uptrend.xyaxis",
                isRead: false,
                type: .general
            ),
            NotificationItem(
                title: "Card Unfrozen",
                message: "Your card has been successfully unfrozen",
                time: "2 days ago",
                icon: "snowflake",
                isRead: true,
                type: .security
            ),
            NotificationItem(
                title: "Airdrop Received",
                message: "You received 500 USDC from airdrop campaign",
                time: "2 days ago",
                icon: "gift.fill",
                isRead: true,
                type: .transaction
            ),
            NotificationItem(
                title: "Exchange Rate Updated",
                message: "New SOL/EUR rate: €150.29",
                time: "3 days ago",
                icon: "arrow.left.arrow.right.circle.fill",
                isRead: true,
                type: .general
            ),
            NotificationItem(
                title: "Staking Reward",
                message: "ETH staking reward: 0.12 ETH (€318.00)",
                time: "3 days ago",
                icon: "diamond.fill",
                isRead: true,
                type: .transaction
            ),
            NotificationItem(
                title: "Weekly Summary",
                message: "Your portfolio gained 5.2% this week",
                time: "4 days ago",
                icon: "chart.bar.fill",
                isRead: true,
                type: .general
            ),
            NotificationItem(
                title: "Security Update",
                message: "Two-factor authentication enabled",
                time: "5 days ago",
                icon: "lock.shield.fill",
                isRead: true,
                type: .security
            ),
            NotificationItem(
                title: "Price Alert: ETH",
                message: "Ethereum price increased by 1.87% in the last 24h",
                time: "6 days ago",
                icon: "chart.line.uptrend.xyaxis",
                isRead: true,
                type: .general
            ),
            NotificationItem(
                title: "Transaction Failed",
                message: "Transaction to 0x7xKX... failed. Insufficient gas",
                time: "6 days ago",
                icon: "xmark.circle.fill",
                isRead: true,
                type: .transaction
            ),
            NotificationItem(
                title: "New Token Available",
                message: "AVAX is now available for trading",
                time: "1 week ago",
                icon: "plus.circle.fill",
                isRead: true,
                type: .general
            )
        ]
    }
    
    // MARK: - Token Management
    func addToken(_ token: Token) {
        guard !tokens.contains(where: { $0.id == token.id }) else { return }
        tokens.append(token)
        HapticManager.shared.notification(.success)
    }
    
    func removeToken(_ token: Token) {
        tokens.removeAll { $0.id == token.id }
        HapticManager.shared.selection()
    }
    
    func toggleFavorite(_ token: Token) {
        if favoriteTokenIds.contains(token.id) {
            favoriteTokenIds.remove(token.id)
        } else {
            favoriteTokenIds.insert(token.id)
        }
        HapticManager.shared.selection()
    }
    
    func isFavorite(_ token: Token) -> Bool {
        favoriteTokenIds.contains(token.id)
    }
    
    var favoriteTokens: [Token] {
        allTokens.filter { favoriteTokenIds.contains($0.id) }
    }
    
    func updateTokenBalance(_ tokenId: UUID, newBalance: Double) {
        if let index = tokens.firstIndex(where: { $0.id == tokenId }) {
            let oldBalance = tokens[index].balance
            tokens[index] = Token(
                symbol: tokens[index].symbol,
                name: tokens[index].name,
                balance: newBalance,
                balanceInUSD: newBalance * tokens[index].price,
                price: tokens[index].price,
                change24h: tokens[index].change24h,
                icon: tokens[index].icon,
                color: tokens[index].color
            )
            
            // If balance becomes 0, remove from visible tokens
            if newBalance <= 0 && oldBalance > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.removeToken(self.tokens[index])
                }
            }
        }
    }
    
    // MARK: - Transaction Management
    func addTransaction(_ transaction: TransactionData) {
        transactions.insert(transaction, at: 0)
        HapticManager.shared.notification(.success)
    }
    
    func deleteTransaction(_ transaction: TransactionData) {
        transactions.removeAll { $0.id == transaction.id }
        HapticManager.shared.selection()
    }
    
    // MARK: - Send Transaction
    func sendTransaction(
        fromToken: Token,
        amount: Double,
        recipientAddress: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let tokenIndex = tokens.firstIndex(where: { $0.id == fromToken.id }),
              tokens[tokenIndex].balance >= amount else {
            completion(false)
            return
        }
        
        // Update balance
        let newBalance = tokens[tokenIndex].balance - amount
        updateTokenBalance(fromToken.id, newBalance: newBalance)
        
        // Add transaction
        let transaction = TransactionData(
            icon: "arrow.up.circle.fill",
            merchant: "Sent to \(recipientAddress.prefix(8))...",
            date: formatDate(Date()),
            amount: "-\(String(format: "%.2f", amount)) \(fromToken.symbol)",
            eurAmount: "€\(String(format: "%.2f", amount * fromToken.price))",
            isCredit: false,
            category: "Transfer",
            tokenSymbol: fromToken.symbol,
            tokenAmount: -amount
        )
        addTransaction(transaction)
        
        // Add notification
        let notification = NotificationItem(
            title: "Transaction Sent",
            message: "\(String(format: "%.2f", amount)) \(fromToken.symbol) sent successfully",
            time: "Just now",
            icon: "checkmark.circle.fill",
            isRead: false,
            type: .transaction
        )
        notifications.insert(notification, at: 0)
        
        completion(true)
    }
    
    // MARK: - Receive Transaction
    func receiveTransaction(
        toToken: Token,
        amount: Double,
        fromAddress: String,
        completion: @escaping (Bool) -> Void
    ) {
        // Update or add token
        if let tokenIndex = tokens.firstIndex(where: { $0.id == toToken.id }) {
            let newBalance = tokens[tokenIndex].balance + amount
            updateTokenBalance(toToken.id, newBalance: newBalance)
        } else {
            // Add new token if not in portfolio
            var newToken = toToken
            newToken = Token(
                symbol: toToken.symbol,
                name: toToken.name,
                balance: amount,
                balanceInUSD: amount * toToken.price,
                price: toToken.price,
                change24h: toToken.change24h,
                icon: toToken.icon,
                color: toToken.color
            )
            addToken(newToken)
        }
        
        // Add transaction
        let transaction = TransactionData(
            icon: "arrow.down.circle.fill",
            merchant: "Received from \(fromAddress.prefix(8))...",
            date: formatDate(Date()),
            amount: "+\(String(format: "%.2f", amount)) \(toToken.symbol)",
            eurAmount: "€\(String(format: "%.2f", amount * toToken.price))",
            isCredit: true,
            category: "Deposit",
            tokenSymbol: toToken.symbol,
            tokenAmount: amount
        )
        addTransaction(transaction)
        
        // Add notification
        let notification = NotificationItem(
            title: "Transaction Received",
            message: "\(String(format: "%.2f", amount)) \(toToken.symbol) received",
            time: "Just now",
            icon: "arrow.down.circle.fill",
            isRead: false,
            type: .transaction
        )
        notifications.insert(notification, at: 0)
        
        completion(true)
    }
    
    // MARK: - Swap Transaction
    func swapTokens(
        fromToken: Token,
        toToken: Token,
        fromAmount: Double,
        toAmount: Double,
        completion: @escaping (Bool) -> Void
    ) {
        guard let fromIndex = tokens.firstIndex(where: { $0.id == fromToken.id }),
              tokens[fromIndex].balance >= fromAmount else {
            completion(false)
            return
        }
        
        // Update from token balance
        let newFromBalance = tokens[fromIndex].balance - fromAmount
        updateTokenBalance(fromToken.id, newBalance: newFromBalance)
        
        // Update or add to token
        if let toIndex = tokens.firstIndex(where: { $0.id == toToken.id }) {
            let newToBalance = tokens[toIndex].balance + toAmount
            updateTokenBalance(toToken.id, newBalance: newToBalance)
        } else {
            // Add new token
            var newToken = toToken
            newToken = Token(
                symbol: toToken.symbol,
                name: toToken.name,
                balance: toAmount,
                balanceInUSD: toAmount * toToken.price,
                price: toToken.price,
                change24h: toToken.change24h,
                icon: toToken.icon,
                color: toToken.color
            )
            addToken(newToken)
        }
        
        // Add transaction
        let transaction = TransactionData(
            icon: "arrow.left.arrow.right",
            merchant: "Swap \(fromToken.symbol) → \(toToken.symbol)",
            date: formatDate(Date()),
            amount: "-\(String(format: "%.2f", fromAmount)) \(fromToken.symbol)",
            eurAmount: "+\(String(format: "%.2f", toAmount)) \(toToken.symbol)",
            isCredit: false,
            category: "Swap",
            tokenSymbol: fromToken.symbol,
            tokenAmount: -fromAmount
        )
        addTransaction(transaction)
        
        // Add notification
        let notification = NotificationItem(
            title: "Swap Completed",
            message: "Swapped \(String(format: "%.2f", fromAmount)) \(fromToken.symbol) for \(String(format: "%.2f", toAmount)) \(toToken.symbol)",
            time: "Just now",
            icon: "arrow.left.arrow.right.circle.fill",
            isRead: false,
            type: .transaction
        )
        notifications.insert(notification, at: 0)
        
        completion(true)
    }
    
    // MARK: - Refresh Data
    func refreshData() {
        isRefreshing = true
        
        Task {
            // Fetch real-time prices off main thread
            await fetchRealTimePrices()
            
            await MainActor.run {
                self.isRefreshing = false
                HapticManager.shared.notification(.success)
            }
        }
    }
    
    // MARK: - Price Updates
    private func startPriceUpdates() {
        // Update prices every 2 minutes (reduced frequency for better performance)
        priceUpdateTimer = Timer.scheduledTimer(withTimeInterval: 120.0, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.fetchRealTimePrices()
            }
        }
    }
    
    // MARK: - Fetch Real-Time Prices
    private func fetchRealTimePrices() async {
        // Get all token symbols
        let symbols = allTokens.map { $0.symbol }
        
        // Fetch prices from API (with caching) - off main thread
        let prices = await priceService.fetchPrices(for: symbols, useCache: true)
        
        // Batch update all tokens on main thread
        await MainActor.run {
            // Update allTokens with real prices
            var updatedAllTokens = allTokens
            for index in 0..<updatedAllTokens.count {
                if let priceData = prices[updatedAllTokens[index].symbol] {
                    let newPrice = priceData.price
                    let newChange = priceData.change24h
                    
                    updatedAllTokens[index] = Token(
                        symbol: updatedAllTokens[index].symbol,
                        name: updatedAllTokens[index].name,
                        balance: updatedAllTokens[index].balance,
                        balanceInUSD: updatedAllTokens[index].balance * newPrice,
                        price: newPrice,
                        change24h: newChange,
                        icon: updatedAllTokens[index].icon,
                        color: updatedAllTokens[index].color
                    )
                }
            }
            allTokens = updatedAllTokens
            
            // Batch update portfolio tokens
            var updatedTokens = tokens
            for index in 0..<updatedTokens.count {
                if let allTokenIndex = allTokens.firstIndex(where: { $0.symbol == updatedTokens[index].symbol }) {
                    let newPrice = allTokens[allTokenIndex].price
                    updatedTokens[index] = Token(
                        symbol: updatedTokens[index].symbol,
                        name: updatedTokens[index].name,
                        balance: updatedTokens[index].balance,
                        balanceInUSD: updatedTokens[index].balance * newPrice,
                        price: newPrice,
                        change24h: allTokens[allTokenIndex].change24h,
                        icon: updatedTokens[index].icon,
                        color: updatedTokens[index].color
                    )
                }
            }
            tokens = updatedTokens
        }
    }
    
    // MARK: - Notification Management
    func markNotificationAsRead(_ notification: NotificationItem) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index] = NotificationItem(
                title: notification.title,
                message: notification.message,
                time: notification.time,
                icon: notification.icon,
                isRead: true,
                type: notification.type
            )
        }
    }
    
    // MARK: - Helper Functions
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "Today, h:mm a"
        } else if calendar.isDateInYesterday(date) {
            formatter.dateFormat = "Yesterday, h:mm a"
        } else {
            formatter.dateFormat = "MMM d, h:mm a"
        }
        
        return formatter.string(from: date)
    }
}


