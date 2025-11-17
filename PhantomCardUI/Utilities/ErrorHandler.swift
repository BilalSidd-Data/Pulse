//
//  ErrorHandler.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import Foundation
import SwiftUI
import Combine

// MARK: - App Error
enum AppError: LocalizedError {
    case networkError(String)
    case priceFetchError
    case authenticationFailed
    case invalidData
    case cacheError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network Error: \(message)"
        case .priceFetchError:
            return "Unable to fetch current prices. Please check your internet connection."
        case .authenticationFailed:
            return "Authentication failed. Please try again."
        case .invalidData:
            return "Invalid data received. Please try again."
        case .cacheError:
            return "Unable to load cached data."
        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Check your internet connection and try again."
        case .priceFetchError:
            return "We'll show you cached prices. Pull down to refresh when connected."
        case .authenticationFailed:
            return "Make sure Face ID/Touch ID is enabled and try again."
        case .invalidData:
            return "Please refresh the app or contact support if the problem persists."
        case .cacheError:
            return "Please refresh the app to load fresh data."
        case .unknown:
            return "If this problem continues, please contact support."
        }
    }
}

// MARK: - Error Handler
class ErrorHandler: ObservableObject {
    static let shared = ErrorHandler()
    
    @Published var currentError: AppError?
    @Published var showError: Bool = false
    
    private init() {}
    
    func handle(_ error: Error) {
        if let appError = error as? AppError {
            currentError = appError
        } else {
            currentError = .networkError(error.localizedDescription)
        }
        showError = true
        HapticManager.shared.notification(.error)
    }
    
    func clearError() {
        currentError = nil
        showError = false
    }
}

// MARK: - Error View Modifier
struct ErrorAlertModifier: ViewModifier {
    @ObservedObject var errorHandler = ErrorHandler.shared
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $errorHandler.showError, presenting: errorHandler.currentError) { error in
                Button("OK") {
                    errorHandler.clearError()
                }
                if error.recoverySuggestion != nil {
                    Button("Retry") {
                        errorHandler.clearError()
                        // Trigger retry if needed
                    }
                }
            } message: { error in
                VStack(alignment: .leading, spacing: 8) {
                    Text(error.errorDescription ?? "An error occurred")
                    if let recovery = error.recoverySuggestion {
                        Text(recovery)
                            .font(.caption)
                    }
                }
            }
    }
}

extension View {
    func errorAlert() -> some View {
        modifier(ErrorAlertModifier())
    }
}

