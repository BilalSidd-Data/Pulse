//
//  BiometricAuth.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import Foundation
import LocalAuthentication

// MARK: - Biometric Authentication Manager
class BiometricAuth {
    static let shared = BiometricAuth()
    
    private let context = LAContext()
    private let reason = "Authenticate to access your wallet"
    
    private init() {}
    
    // MARK: - Check Biometric Availability
    func canEvaluatePolicy() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    // MARK: - Get Biometric Type
    func biometricType() -> BiometricType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        case .opticID:
            return .opticID
        default:
            return .none
        }
    }
    
    // MARK: - Authenticate
    func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        context.localizedFallbackTitle = "Use Passcode"
        
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason
        ) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    // MARK: - Check if Authentication is Enabled
    func isAuthenticationEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "biometricAuthEnabled")
    }
    
    // MARK: - Enable/Disable Authentication
    func setAuthenticationEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "biometricAuthEnabled")
    }
}

// MARK: - Biometric Type
enum BiometricType {
    case faceID
    case touchID
    case opticID
    case none
}

