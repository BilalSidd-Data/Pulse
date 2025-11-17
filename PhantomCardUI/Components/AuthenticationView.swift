//
//  AuthenticationView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Authentication View
struct AuthenticationView: View {
    private let biometricAuth = BiometricAuth.shared
    @State private var isAuthenticated = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    let onAuthenticated: () -> Void
    
    var body: some View {
        ZStack {
            Color.deepDark.ignoresSafeArea()
            
            if isAuthenticated {
                Color.clear
            } else {
                authenticationContent
            }
        }
        .onAppear {
            checkAuthentication()
        }
    }
    
    // MARK: - Authentication Content
    private var authenticationContent: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // App Icon/Logo
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.phantomPurple, Color.phantomGold],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 12) {
                Text("Secure Access")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Authenticate to access your wallet")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            // Biometric Button
            if biometricAuth.canEvaluatePolicy() {
                Button(action: authenticate) {
                    HStack(spacing: 12) {
                        Image(systemName: biometricIcon)
                            .font(.title3)
                        Text(biometricText)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [Color.phantomPurple, Color.phantomGold],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: RoundedRectangle(cornerRadius: 16)
                    )
                }
                .padding(.horizontal, 32)
            } else {
                // Fallback to passcode
                Button(action: authenticate) {
                    HStack(spacing: 12) {
                        Image(systemName: "key.fill")
                            .font(.title3)
                        Text("Use Passcode")
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [Color.phantomPurple, Color.phantomGold],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: RoundedRectangle(cornerRadius: 16)
                    )
                }
                .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .alert("Authentication Failed", isPresented: $showError) {
            Button("OK") { }
            Button("Retry") {
                authenticate()
            }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Biometric Icon
    private var biometricIcon: String {
        switch biometricAuth.biometricType() {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        case .opticID:
            return "eye.fill"
        case .none:
            return "key.fill"
        }
    }
    
    // MARK: - Biometric Text
    private var biometricText: String {
        switch biometricAuth.biometricType() {
        case .faceID:
            return "Authenticate with Face ID"
        case .touchID:
            return "Authenticate with Touch ID"
        case .opticID:
            return "Authenticate with Optic ID"
        case .none:
            return "Authenticate"
        }
    }
    
    // MARK: - Check Authentication
    private func checkAuthentication() {
        if biometricAuth.isAuthenticationEnabled() {
            authenticate()
        } else {
            // If not enabled, skip authentication
            isAuthenticated = true
            onAuthenticated()
        }
    }
    
    // MARK: - Authenticate
    private func authenticate() {
        if !biometricAuth.isAuthenticationEnabled() {
            isAuthenticated = true
            onAuthenticated()
            return
        }
        
        biometricAuth.authenticate { success, error in
            if success {
                isAuthenticated = true
                HapticManager.shared.notification(.success)
                onAuthenticated()
            } else {
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                    HapticManager.shared.notification(.error)
                }
            }
        }
    }
}

