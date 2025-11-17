//
//  PriceService.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import Foundation
import Combine

// MARK: - Price Service
class PriceService: ObservableObject {
    static let shared = PriceService()
    
    // MARK: - CoinGecko API Mapping
    private let coinGeckoMapping: [String: String] = [
        "SOL": "solana",
        "BTC": "bitcoin",
        "ETH": "ethereum",
        "BNB": "binancecoin",
        "XRP": "ripple",
        "ADA": "cardano",
        "DOGE": "dogecoin",
        "MATIC": "matic-network",
        "DOT": "polkadot",
        "AVAX": "avalanche-2",
        "USDC": "usd-coin",
        "USDT": "tether",
        "EUR": "eur" // Fiat currency - handled separately
    ]
    
    private let baseURL = "https://api.coingecko.com/api/v3"
    private var cancellables = Set<AnyCancellable>()
    private let priceCache = PriceCache.shared
    
    // Optimized URLSession configuration
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 15
        configuration.waitsForConnectivity = false
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    
    private init() {}
    
    // MARK: - Fetch Prices
    func fetchPrices(for symbols: [String], useCache: Bool = true) async -> [String: PriceData] {
        // Try to get cached prices first if available and valid
        if useCache, let cachedPrices = priceCache.getCachedPrices() {
            // Check if we have all requested symbols in cache
            let hasAllSymbols = symbols.allSatisfy { cachedPrices[$0] != nil }
            if hasAllSymbols {
                return cachedPrices
            }
        }
        
        var prices: [String: PriceData] = [:]
        
        // Filter out fiat currencies
        let cryptoSymbols = symbols.filter { $0 != "EUR" }
        let coinIds = cryptoSymbols.compactMap { coinGeckoMapping[$0] }
        
        guard !coinIds.isEmpty else {
            // Return cached prices if available, even if incomplete
            return priceCache.getCachedPrices() ?? prices
        }
        
        // Create comma-separated list of coin IDs
        let idsString = coinIds.joined(separator: ",")
        
        // Build URL - Fetch prices in EUR
        guard let url = URL(string: "\(baseURL)/simple/price?ids=\(idsString)&vs_currencies=eur&include_24hr_change=true") else {
            // Return cached prices if URL creation fails
            return priceCache.getCachedPrices() ?? prices
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            // Check if response is valid
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 {
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    // Parse response - prices are now in EUR
                for (coinId, coinData) in json {
                    if let coinInfo = coinData as? [String: Any],
                           let price = coinInfo["eur"] as? Double,
                           let change24h = coinInfo["eur_24h_change"] as? Double {
                        
                        // Find symbol from coinId
                        if let symbol = coinGeckoMapping.first(where: { $0.value == coinId })?.key {
                            prices[symbol] = PriceData(price: price, change24h: change24h)
                        }
                    }
                    }
                    
                    // Cache the new prices
                    priceCache.cachePrices(prices)
                }
            }
        } catch {
            print("Error fetching prices: \(error.localizedDescription)")
            // Return cached prices if network request fails
            if let cachedPrices = priceCache.getCachedPrices() {
                return cachedPrices
            }
        }
        
        // Handle EUR separately (fiat currency)
        if symbols.contains("EUR") {
            prices["EUR"] = PriceData(price: 1.0, change24h: 0.0) // EUR is base currency
        }
        
        return prices
    }
    
    // MARK: - Fetch All Prices
    func fetchAllPrices() async -> [String: PriceData] {
        let allSymbols = Array(coinGeckoMapping.keys)
        return await fetchPrices(for: allSymbols)
    }
}

// MARK: - Price Data
struct PriceData: Codable {
    let price: Double
    let change24h: Double
}

