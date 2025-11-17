//
//  SettingsView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isNotificationsEnabled = true
    @State private var isBiometricEnabled = true
    @State private var showAbout = false
    @State private var showSecurity = false
    @State private var showNetworkSettings = false
    @State private var showWalletManagement = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Section
                    profileSection
                    
                    // Security Section
                    securitySection
                    
                    // Preferences Section
                    preferencesSection
                    
                    // Network Section
                    networkSection
                    
                    // Wallet Management
                    walletManagementSection
                    
                    // Support Section
                    supportSection
                    
                    // About Section
                    aboutSection
                    
                    // Sign Out
                    signOutButton
                }
                .padding()
            }
            .background(Color.deepDark.ignoresSafeArea())
            .navigationTitle("Settings")
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
        .sheet(isPresented: $showAbout) {
            AboutView(isPresented: $showAbout)
        }
        .sheet(isPresented: $showSecurity) {
            SecuritySettingsView(isPresented: $showSecurity)
        }
        .sheet(isPresented: $showNetworkSettings) {
            NetworkSettingsView(isPresented: $showNetworkSettings)
        }
        .sheet(isPresented: $showWalletManagement) {
            WalletManagementView(isPresented: $showWalletManagement)
        }
    }
    
    // MARK: - Profile Section
    private var profileSection: some View {
        VStack(spacing: 16) {
            SettingsSectionHeader(title: "Profile")
            
            SettingsRow(
                icon: "person.circle.fill",
                title: "Edit Profile",
                iconColor: .blue,
                showChevron: true
            ) {
                // Edit profile action
            }
            
            SettingsRow(
                icon: "wallet.pass.fill",
                title: "Wallet Address",
                iconColor: .phantomPurple,
                showChevron: true
            ) {
                // Show wallet address
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Security Section
    private var securitySection: some View {
        VStack(spacing: 16) {
            SettingsSectionHeader(title: "Security")
            
            SettingsRow(
                icon: "faceid",
                title: "Biometric Authentication",
                iconColor: .green,
                showToggle: true,
                toggleValue: $isBiometricEnabled
            )
            
            SettingsRow(
                icon: "lock.shield.fill",
                title: "Security Settings",
                iconColor: .red,
                showChevron: true
            ) {
                showSecurity = true
            }
            
            SettingsRow(
                icon: "key.fill",
                title: "Change Password",
                iconColor: .orange,
                showChevron: true
            ) {
                // Change password
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Preferences Section
    private var preferencesSection: some View {
        VStack(spacing: 16) {
            SettingsSectionHeader(title: "Preferences")
            
            SettingsRow(
                icon: "bell.fill",
                title: "Notifications",
                iconColor: .phantomGold,
                showToggle: true,
                toggleValue: $isNotificationsEnabled
            )
            
            SettingsRow(
                icon: "moon.fill",
                title: "Dark Mode",
                iconColor: .indigo,
                showToggle: true,
                toggleValue: .constant(true)
            )
            
            SettingsRow(
                icon: "globe",
                title: "Language",
                iconColor: .blue,
                showChevron: true,
                subtitle: "English"
            ) {
                // Language selection
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Network Section
    private var networkSection: some View {
        VStack(spacing: 16) {
            SettingsSectionHeader(title: "Network")
            
            SettingsRow(
                icon: "network",
                title: "Network Settings",
                iconColor: .cyan,
                showChevron: true,
                subtitle: "Mainnet"
            ) {
                showNetworkSettings = true
            }
            
            SettingsRow(
                icon: "server.rack",
                title: "RPC Endpoint",
                iconColor: .purple,
                showChevron: true,
                subtitle: "Default"
            ) {
                // RPC settings
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Wallet Management Section
    private var walletManagementSection: some View {
        VStack(spacing: 16) {
            SettingsSectionHeader(title: "Wallet")
            
            SettingsRow(
                icon: "wallet.pass.fill",
                title: "Manage Wallets",
                iconColor: .phantomPurple,
                showChevron: true
            ) {
                showWalletManagement = true
            }
            
            SettingsRow(
                icon: "plus.circle.fill",
                title: "Add New Wallet",
                iconColor: .green,
                showChevron: true
            ) {
                // Add wallet
            }
            
            SettingsRow(
                icon: "arrow.down.circle.fill",
                title: "Import Wallet",
                iconColor: .blue,
                showChevron: true
            ) {
                // Import wallet
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Support Section
    private var supportSection: some View {
        VStack(spacing: 16) {
            SettingsSectionHeader(title: "Support")
            
            SettingsRow(
                icon: "questionmark.circle.fill",
                title: "Help Center",
                iconColor: .blue,
                showChevron: true
            ) {
                // Help center
            }
            
            SettingsRow(
                icon: "envelope.fill",
                title: "Contact Support",
                iconColor: .green,
                showChevron: true
            ) {
                // Contact support
            }
            
            SettingsRow(
                icon: "doc.text.fill",
                title: "Terms of Service",
                iconColor: .gray,
                showChevron: true
            ) {
                // Terms
            }
            
            SettingsRow(
                icon: "hand.raised.fill",
                title: "Privacy Policy",
                iconColor: .gray,
                showChevron: true
            ) {
                // Privacy
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(spacing: 16) {
            SettingsSectionHeader(title: "About")
            
            SettingsRow(
                icon: "info.circle.fill",
                title: "About",
                iconColor: .phantomPurple,
                showChevron: true,
                subtitle: "Version 1.0.0"
            ) {
                showAbout = true
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    // MARK: - Sign Out Button
    private var signOutButton: some View {
        Button {
            HapticManager.shared.impact(.medium)
            // Sign out logic
        } label: {
            Text("Sign Out")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.red.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }
}

// MARK: - Settings Section Header
struct SettingsSectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
                .textCase(.uppercase)
                .tracking(1)
            Spacer()
        }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    var showChevron: Bool = false
    var showToggle: Bool = false
    var toggleValue: Binding<Bool>? = nil
    var subtitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            if let action = action {
                HapticManager.shared.selection()
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                if showToggle, let toggleValue = toggleValue {
                    Toggle("", isOn: toggleValue)
                        .tint(iconColor)
                } else if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - About View
struct AboutView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.phantomPurple, Color.phantomGold],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "wallet.pass.fill")
                            .font(.system(size: 50, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    Text("Phantom Wallet")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("A secure, fast, and user-friendly cryptocurrency wallet for managing your digital assets.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .background(Color.deepDark.ignoresSafeArea())
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - Security Settings View
struct SecuritySettingsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Security Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    // Security options here
                }
            }
            .background(Color.deepDark.ignoresSafeArea())
            .navigationTitle("Security")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - Network Settings View
struct NetworkSettingsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Network Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    // Network options here
                }
            }
            .background(Color.deepDark.ignoresSafeArea())
            .navigationTitle("Network")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - Wallet Management View
struct WalletManagementView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Manage Wallets")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    // Wallet list here
                }
            }
            .background(Color.deepDark.ignoresSafeArea())
            .navigationTitle("Wallets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

