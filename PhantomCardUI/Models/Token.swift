//
//  Token.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Token Model
struct Token: Identifiable, Equatable {
    let id = UUID()
    let symbol: String
    let name: String
    let balance: Double
    let balanceInUSD: Double
    let price: Double
    let change24h: Double
    let icon: String
    let color: Color
    
    static func == (lhs: Token, rhs: Token) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Top Cryptocurrencies Data
extension Token {
    static let topCryptocurrencies: [Token] = [
        Token(
            symbol: "SOL",
            name: "Solana",
            balance: 13.32,
            balanceInUSD: 2001.86,
            price: 150.29,
            change24h: 2.45,
            icon: "sun.max.fill",
            color: .purple
        ),
        Token(
            symbol: "BTC",
            name: "Bitcoin",
            balance: 0.058,
            balanceInUSD: 2508.50,
            price: 43250.00,
            change24h: 2.34,
            icon: "bitcoinsign.circle.fill",
            color: .orange
        ),
        Token(
            symbol: "ETH",
            name: "Ethereum",
            balance: 0.755,
            balanceInUSD: 2000.75,
            price: 2650.00,
            change24h: 1.87,
            icon: "diamond.fill",
            color: .blue
        ),
        Token(
            symbol: "BNB",
            name: "BNB",
            balance: 1.59,
            balanceInUSD: 501.65,
            price: 315.50,
            change24h: -0.45,
            icon: "flame.fill",
            color: .yellow
        ),
        Token(
            symbol: "XRP",
            name: "Ripple",
            balance: 0.0,
            balanceInUSD: 0.0,
            price: 0.62,
            change24h: 3.21,
            icon: "waveform.path",
            color: .black
        ),
        Token(
            symbol: "ADA",
            name: "Cardano",
            balance: 0.0,
            balanceInUSD: 0.0,
            price: 0.48,
            change24h: 1.23,
            icon: "leaf.fill",
            color: .green
        ),
        Token(
            symbol: "DOGE",
            name: "Dogecoin",
            balance: 0.0,
            balanceInUSD: 0.0,
            price: 0.085,
            change24h: 4.56,
            icon: "pawprint.fill",
            color: .yellow
        ),
        Token(
            symbol: "MATIC",
            name: "Polygon",
            balance: 0.0,
            balanceInUSD: 0.0,
            price: 0.89,
            change24h: 2.11,
            icon: "hexagon.fill",
            color: .purple
        ),
        Token(
            symbol: "DOT",
            name: "Polkadot",
            balance: 0.0,
            balanceInUSD: 0.0,
            price: 7.25,
            change24h: -1.34,
            icon: "circle.grid.hex.fill",
            color: .pink
        ),
        Token(
            symbol: "AVAX",
            name: "Avalanche",
            balance: 3.90,
            balanceInUSD: 150.15,
            price: 38.50,
            change24h: 1.98,
            icon: "snowflake",
            color: .red
        ),
        Token(
            symbol: "USDC",
            name: "USD Coin",
            balance: 500.0,
            balanceInUSD: 500.0,
            price: 1.0,
            change24h: 0.01,
            icon: "dollarsign.circle.fill",
            color: .blue
        ),
        Token(
            symbol: "USDT",
            name: "Tether",
            balance: 0.0,
            balanceInUSD: 0.0,
            price: 1.0,
            change24h: 0.01,
            icon: "dollarsign.square.fill",
            color: .green
        ),
        Token(
            symbol: "EUR",
            name: "Euro",
            balance: 350.0,
            balanceInUSD: 350.0,
            price: 1.0,
            change24h: 0.12,
            icon: "eurosign.circle.fill",
            color: .blue
        )
    ]
}

