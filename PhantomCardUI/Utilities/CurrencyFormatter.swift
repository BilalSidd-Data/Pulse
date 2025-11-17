//
//  CurrencyFormatter.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import Foundation

// MARK: - Currency Formatter
struct CurrencyFormatter {
    static let shared = CurrencyFormatter()
    
    private let formatter: NumberFormatter
    
    private init() {
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.currencySymbol = "€"
        formatter.locale = Locale(identifier: "it_IT") // Italian locale for EUR formatting
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
    }
    
    // MARK: - Format Currency
    func format(_ amount: Double) -> String {
        return formatter.string(from: NSNumber(value: amount)) ?? "€\(String(format: "%.2f", amount))"
    }
    
    // MARK: - Format Currency with Symbol
    func formatWithSymbol(_ amount: Double) -> String {
        return "€\(String(format: "%.2f", amount))"
    }
    
    // MARK: - Format Large Amounts
    func formatLarge(_ amount: Double) -> String {
        if amount >= 1_000_000 {
            return "€\(String(format: "%.2f", amount / 1_000_000))M"
        } else if amount >= 1_000 {
            return "€\(String(format: "%.1f", amount / 1_000))K"
        } else {
            return formatWithSymbol(amount)
        }
    }
}

