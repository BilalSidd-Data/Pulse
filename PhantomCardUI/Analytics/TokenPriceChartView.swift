//
//  TokenPriceChartView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Token Price Chart View
struct TokenPriceChartView: View {
    let token: Token
    @Environment(\.dismiss) var dismiss
    @State private var selectedTimeframe: Timeframe = .day7
    
    enum Timeframe: String, CaseIterable {
        case day1 = "1D"
        case day7 = "7D"
        case day30 = "30D"
        case day90 = "90D"
        case all = "ALL"
    }
    
    private var priceData: [PriceDataPoint] {
        generatePriceData(for: selectedTimeframe)
    }
    
    private var priceChange: Double {
        guard let first = priceData.first?.price,
              let last = priceData.last?.price,
              first > 0 else { return 0 }
        return ((last - first) / first) * 100
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Token Header
                    tokenHeader
                    
                    // Price Display
                    priceDisplay
                    
                    // Timeframe Selector
                    timeframeSelector
                    
                    // Chart
                    priceChart
                    
                    // Price Statistics
                    priceStatistics
                    
                    // Market Info
                    marketInfo
                }
                .padding()
            }
            .background(Color.deepDark.ignoresSafeArea())
            .navigationTitle(token.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Token Header
    private var tokenHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(token.color.opacity(0.2))
                    .frame(width: 64, height: 64)
                
                Image(systemName: token.icon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(token.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(token.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(token.symbol)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Price Display
    private var priceDisplay: some View {
        VStack(spacing: 8) {
            Text("Current Price")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            Text(CurrencyFormatter.shared.formatWithSymbol(token.price))
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.white, token.color.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            HStack(spacing: 8) {
                Image(systemName: token.change24h >= 0 ? "arrow.up.right" : "arrow.down.right")
                    .font(.caption)
                    .foregroundColor(token.change24h >= 0 ? .green : .red)
                
                Text("\(token.change24h >= 0 ? "+" : "")\(String(format: "%.2f", token.change24h))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(token.change24h >= 0 ? .green : .red)
                
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
                                    token.color.opacity(0.3),
                                    token.color.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
    }
    
    // MARK: - Timeframe Selector
    private var timeframeSelector: some View {
        HStack(spacing: 12) {
            ForEach(Timeframe.allCases, id: \.self) { timeframe in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTimeframe = timeframe
                    }
                    HapticManager.shared.selection()
                } label: {
                    Text(timeframe.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedTimeframe == timeframe ? .white : .white.opacity(0.7))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedTimeframe == timeframe ? token.color : Color.clear)
                        )
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Price Chart
    private var priceChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Price History")
                .font(.headline)
                .foregroundColor(.white)
            
            SimplePriceChart(data: priceData, color: token.color)
                .frame(height: 220)
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
                                    token.color.opacity(0.2),
                                    token.color.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    // MARK: - Price Statistics
    private var priceStatistics: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Price Statistics")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                StatRow(label: "24h High", value: CurrencyFormatter.shared.formatWithSymbol(token.price * 1.05))
                StatRow(label: "24h Low", value: CurrencyFormatter.shared.formatWithSymbol(token.price * 0.95))
                StatRow(label: "Price Change", value: "\(priceChange >= 0 ? "+" : "")\(String(format: "%.2f", priceChange))%")
                StatRow(label: "Market Cap", value: CurrencyFormatter.shared.formatLarge(token.price * 1000000))
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
    }
    
    // MARK: - Market Info
    private var marketInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Market Information")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                InfoRow(icon: "chart.line.uptrend.xyaxis", text: "Volume: \(CurrencyFormatter.shared.formatLarge(token.price * 50000))")
                InfoRow(icon: "arrow.up.arrow.down", text: "24h Change: \(token.change24h >= 0 ? "+" : "")\(String(format: "%.2f", token.change24h))%")
                InfoRow(icon: "clock.fill", text: "Last updated: Just now")
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
    }
    
    // MARK: - Helper Functions
    private func generatePriceData(for timeframe: Timeframe) -> [PriceDataPoint] {
        let days: Int
        switch timeframe {
        case .day1: days = 1
        case .day7: days = 7
        case .day30: days = 30
        case .day90: days = 90
        case .all: days = 180
        }
        
        let basePrice = token.price
        var data: [PriceDataPoint] = []
        let calendar = Calendar.current
        
        for i in 0..<days {
            let date = calendar.date(byAdding: .day, value: -days + i, to: Date()) ?? Date()
            // Simulate realistic price movements
            let variation = Double.random(in: -0.02...0.02)
            let trend = Double(i) / Double(days) * (token.change24h / 100) // Follow 24h trend
            let price = basePrice * (1 + variation + trend)
            data.append(PriceDataPoint(date: date, price: max(price, basePrice * 0.8)))
        }
        
        return data
    }
}

// MARK: - Price Data Point
struct PriceDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

// MARK: - Simple Price Chart (Fallback for iOS < 16)
struct SimplePriceChart: View {
    let data: [PriceDataPoint]
    let color: Color
    
    private var minPrice: Double {
        data.map { $0.price }.min() ?? 0
    }
    
    private var maxPrice: Double {
        data.map { $0.price }.max() ?? 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Grid lines
                Path { path in
                    for i in 0...4 {
                        let y = CGFloat(i) * geometry.size.height / 4
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                }
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                
                // Chart line
                Path { path in
                    guard !data.isEmpty else { return }
                    
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let stepX = width / CGFloat(max(data.count - 1, 1))
                    
                    for (index, point) in data.enumerated() {
                        let x = CGFloat(index) * stepX
                        let normalizedPrice = (point.price - minPrice) / (maxPrice - minPrice)
                        let y = height - (CGFloat(normalizedPrice) * height)
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(
                    LinearGradient(
                        colors: [color, color.opacity(0.6)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                )
                
                // Gradient fill
                Path { path in
                    guard !data.isEmpty else { return }
                    
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let stepX = width / CGFloat(max(data.count - 1, 1))
                    
                    path.move(to: CGPoint(x: 0, y: height))
                    
                    for (index, point) in data.enumerated() {
                        let x = CGFloat(index) * stepX
                        let normalizedPrice = (point.price - minPrice) / (maxPrice - minPrice)
                        let y = height - (CGFloat(normalizedPrice) * height)
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    path.addLine(to: CGPoint(x: geometry.size.width, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [
                            color.opacity(0.3),
                            color.opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
}

