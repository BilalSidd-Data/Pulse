//
//  PriceCache.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import Foundation

// MARK: - Price Cache Manager
class PriceCache {
    static let shared = PriceCache()
    
    private let userDefaults = UserDefaults.standard
    private let cacheKey = "cached_prices"
    private let cacheTimestampKey = "cached_prices_timestamp"
    private let cacheExpirationTime: TimeInterval = 180 // 3 minutes (optimized for better performance)
    
    private init() {}
    
    // MARK: - Cache Price Data
    func cachePrices(_ prices: [String: PriceData]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(prices) {
            userDefaults.set(encoded, forKey: cacheKey)
            userDefaults.set(Date().timeIntervalSince1970, forKey: cacheTimestampKey)
        }
    }
    
    // MARK: - Get Cached Prices
    func getCachedPrices() -> [String: PriceData]? {
        guard let data = userDefaults.data(forKey: cacheKey),
              let timestamp = userDefaults.object(forKey: cacheTimestampKey) as? TimeInterval else {
            return nil
        }
        
        // Check if cache is still valid
        let cacheAge = Date().timeIntervalSince1970 - timestamp
        guard cacheAge < cacheExpirationTime else {
            // Cache expired
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode([String: PriceData].self, from: data)
    }
    
    // MARK: - Clear Cache
    func clearCache() {
        userDefaults.removeObject(forKey: cacheKey)
        userDefaults.removeObject(forKey: cacheTimestampKey)
    }
    
    // MARK: - Check if Cache is Valid
    func isCacheValid() -> Bool {
        guard let timestamp = userDefaults.object(forKey: cacheTimestampKey) as? TimeInterval else {
            return false
        }
        let cacheAge = Date().timeIntervalSince1970 - timestamp
        return cacheAge < cacheExpirationTime
    }
}


