//
//  PortfolioAnalyticsView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Portfolio Analytics View
struct PortfolioAnalyticsView: View {
    @EnvironmentObject private var appState: AppStateManager
    @State private var selectedTimeframe: Timeframe = .day7
    @Environment(\.dismiss) var dismiss
    
    enum Timeframe: String, CaseIterable {
        case day1 = "1D"
        case day7 = "7D"
        case day30 = "30D"
        case day90 = "90D"
        case all = "ALL"
    }
    
    private var tokens: [Token] {
        appState.tokens
    }
    
    private var totalValue: Double {
        tokens.reduce(0) { $0 + $1.balanceInUSD }
    }
    
    private var portfolioData: [PortfolioDataPoint] {
        generatePortfolioData(for: selectedTimeframe)
    }
    
    private var totalChange: Double {
        guard let first = portfolioData.first?.value,
              let last = portfolioData.last?.value,
              first > 0 else { return 0 }
        return ((last - first) / first) * 100
    }
    
    private var totalGain: Double {
        guard let first = portfolioData.first?.value,
              let last = portfolioData.last?.value else { return 0 }
        return last - first
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Value Display
                    valueDisplay
                    
                    // Timeframe Selector
                    timeframeSelector
                    
                    // Performance Metrics
                    performanceMetrics
                    
                    // Chart
                    portfolioChart
                    
                    // Token Distribution
                    tokenDistribution
                    
                    // Statistics
                    statisticsSection
                }
                .padding()
            }
            .background(Color.deepDark.ignoresSafeArea())
            .navigationTitle("Portfolio Analytics")
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
    
    // MARK: - Value Display
    private var valueDisplay: some View {
        VStack(spacing: 8) {
            Text("Total Portfolio Value")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
            
            Text(CurrencyFormatter.shared.formatWithSymbol(totalValue))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.white, Color.phantomPurple.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            HStack(spacing: 8) {
                Image(systemName: totalChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                    .font(.caption)
                    .foregroundColor(totalChange >= 0 ? .green : .red)
                
                Text("\(totalChange >= 0 ? "+" : "")\(String(format: "%.2f", totalChange))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(totalChange >= 0 ? .green : .red)
                
                Text("(\(selectedTimeframe.rawValue))")
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
                                .fill(selectedTimeframe == timeframe ? Color.phantomPurple : Color.clear)
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
    
    // MARK: - Performance Metrics
    private var performanceMetrics: some View {
        HStack(spacing: 16) {
            MetricCard(
                title: "Total Gain",
                value: CurrencyFormatter.shared.formatWithSymbol(totalGain),
                color: totalGain >= 0 ? .green : .red,
                icon: totalGain >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
            )
            
            MetricCard(
                title: "Best Performer",
                value: bestPerformer?.symbol ?? "N/A",
                color: .phantomGold,
                icon: "star.fill"
            )
        }
    }
    
    private var bestPerformer: Token? {
        tokens.max(by: { $0.change24h < $1.change24h })
    }
    
    // MARK: - Portfolio Chart
    private var portfolioChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Portfolio Value")
                .font(.headline)
                .foregroundColor(.white)
            
            SimpleLineChart(data: portfolioData)
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
    
    // MARK: - Token Distribution
    private var tokenDistribution: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Token Distribution")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                ForEach(tokens.sorted(by: { $0.balanceInUSD > $1.balanceInUSD })) { token in
                    TokenDistributionRow(token: token, totalValue: totalValue)
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
    }
    
    // MARK: - Statistics Section
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                StatRow(label: "Total Tokens", value: "\(tokens.count)")
                StatRow(label: "Active Holdings", value: "\(tokens.filter { $0.balance > 0 }.count)")
                StatRow(label: "Avg. Price Change", value: String(format: "%.2f%%", averageChange))
                StatRow(label: "Largest Holding", value: largestHolding?.symbol ?? "N/A")
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
    
    private var averageChange: Double {
        guard !tokens.isEmpty else { return 0 }
        return tokens.reduce(0) { $0 + $1.change24h } / Double(tokens.count)
    }
    
    private var largestHolding: Token? {
        tokens.max(by: { $0.balanceInUSD < $1.balanceInUSD })
    }
    
    // MARK: - Helper Functions
    private func generatePortfolioData(for timeframe: Timeframe) -> [PortfolioDataPoint] {
        let days: Int
        switch timeframe {
        case .day1: days = 1
        case .day7: days = 7
        case .day30: days = 30
        case .day90: days = 90
        case .all: days = 180
        }
        
        let baseValue = totalValue
        var data: [PortfolioDataPoint] = []
        let calendar = Calendar.current
        
        for i in 0..<days {
            let date = calendar.date(byAdding: .day, value: -days + i, to: Date()) ?? Date()
            // Simulate realistic price fluctuations
            let variation = Double.random(in: -0.03...0.03)
            let trend = Double(i) / Double(days) * 0.05 // Slight upward trend
            let value = baseValue * (1 + variation + trend)
            data.append(PortfolioDataPoint(date: date, value: max(value, baseValue * 0.7)))
        }
        
        return data
    }
}

// MARK: - Portfolio Data Point
struct PortfolioDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

// MARK: - Metric Card
struct MetricCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}

// MARK: - Token Distribution Row
struct TokenDistributionRow: View {
    let token: Token
    let totalValue: Double
    
    private var percentage: Double {
        guard totalValue > 0 else { return 0 }
        return (token.balanceInUSD / totalValue) * 100
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ZStack {
                    Circle()
                        .fill(token.color.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: token.icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(token.color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(token.symbol)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(CurrencyFormatter.shared.formatWithSymbol(token.balanceInUSD))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                Text("\(String(format: "%.1f", percentage))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [token.color, token.color.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

// MARK: - Stat Row
struct StatRow: View {
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

// MARK: - Simple Line Chart (Fallback for iOS < 16)
struct SimpleLineChart: View {
    let data: [PortfolioDataPoint]
    
    private var minValue: Double {
        data.map { $0.value }.min() ?? 0
    }
    
    private var maxValue: Double {
        data.map { $0.value }.max() ?? 1
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
                        let normalizedValue = (point.value - minValue) / (maxValue - minValue)
                        let y = height - (CGFloat(normalizedValue) * height)
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(
                    LinearGradient(
                        colors: [Color.phantomPurple, Color.phantomGold],
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
                        let normalizedValue = (point.value - minValue) / (maxValue - minValue)
                        let y = height - (CGFloat(normalizedValue) * height)
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    
                    path.addLine(to: CGPoint(x: geometry.size.width, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [
                            Color.phantomPurple.opacity(0.3),
                            Color.phantomGold.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
}

