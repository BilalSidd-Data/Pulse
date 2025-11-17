//
//  PhantomCardUIApp.swift
//  PhantomCardUI
//
//  Created by Muhammad Bilal Siddiqui on 07/11/25.
//

import SwiftUI

@main
struct PhantomCardUIApp: App {
    @StateObject private var appState = AppStateManager.shared
    @StateObject private var errorHandler = ErrorHandler.shared
    @State private var isOnboardingComplete = UserDefaults.standard.bool(forKey: "isOnboardingComplete")
    @State private var isAuthenticated = false
    
    var body: some Scene {
        WindowGroup {
            ContentViewWithAuth(
                isOnboardingComplete: $isOnboardingComplete,
                isAuthenticated: $isAuthenticated,
                appState: appState
            )
        }
    }
}

// MARK: - Content View With Auth
struct ContentViewWithAuth: View {
    @Binding var isOnboardingComplete: Bool
    @Binding var isAuthenticated: Bool
    let appState: AppStateManager
    
    var body: some View {
        Group {
            if isOnboardingComplete {
                if isAuthenticated {
                    MainTabView()
                        .environmentObject(appState)
                        .errorAlert()
                } else {
                    AuthenticationView {
                        isAuthenticated = true
                    }
                }
            } else {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                    .onChange(of: isOnboardingComplete) { oldValue, newValue in
                        UserDefaults.standard.set(newValue, forKey: "isOnboardingComplete")
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // Re-authenticate when app comes to foreground
            if isOnboardingComplete {
                isAuthenticated = false
            }
        }
    }
}
