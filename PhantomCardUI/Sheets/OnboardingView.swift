//
//  OnboardingView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Onboarding View
struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showCreateWallet = false
    @State private var showImportWallet = false
    @Binding var isOnboardingComplete: Bool
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Color.deepDark,
                    Color.phantomPurple.opacity(0.3),
                    Color.deepDark
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if !showCreateWallet && !showImportWallet {
                onboardingContent
            } else if showCreateWallet {
                CreateWalletView(isPresented: $showCreateWallet, isOnboardingComplete: $isOnboardingComplete)
            } else if showImportWallet {
                ImportWalletView(isPresented: $showImportWallet, isOnboardingComplete: $isOnboardingComplete)
            }
        }
    }
    
    private var onboardingContent: some View {
        VStack(spacing: 0) {
            // Skip Button
            HStack {
                Spacer()
                Button("Skip") {
                    isOnboardingComplete = true
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .padding()
            }
            
            // Page Content
            TabView(selection: $currentPage) {
                OnboardingPage(
                    icon: "wallet.pass.fill",
                    title: "Your Crypto Wallet",
                    description: "Secure, fast, and easy-to-use wallet for managing your digital assets",
                    gradient: [Color.phantomPurple, Color.phantomGold]
                )
                .tag(0)
                
                OnboardingPage(
                    icon: "shield.checkered",
                    title: "Secure & Private",
                    description: "Your keys, your crypto. We never have access to your funds",
                    gradient: [Color.green, Color.blue]
                )
                .tag(1)
                
                OnboardingPage(
                    icon: "arrow.left.arrow.right.circle.fill",
                    title: "Swap Instantly",
                    description: "Trade cryptocurrencies instantly with low fees and best rates",
                    gradient: [Color.phantomGold, Color.orange]
                )
                .tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            // Action Buttons
            VStack(spacing: 16) {
                Button {
                    HapticManager.shared.impact(.medium)
                    showCreateWallet = true
                } label: {
                    Text("Create New Wallet")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [Color.phantomPurple, Color.phantomGold],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                        )
                }
                .buttonStyle(.plain)
                
                Button {
                    HapticManager.shared.selection()
                    showImportWallet = true
                } label: {
                    Text("Import Existing Wallet")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.phantomPurple)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.phantomPurple, lineWidth: 2)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Onboarding Page
struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let gradient: [Color]
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: gradient[0].opacity(0.5), radius: 20, x: 0, y: 10)
                
                Image(systemName: icon)
                    .font(.system(size: 50, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Text
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

// MARK: - Create Wallet View
struct CreateWalletView: View {
    @Binding var isPresented: Bool
    @Binding var isOnboardingComplete: Bool
    @State private var walletName: String = ""
    @State private var showSeedPhrase = false
    @State private var seedPhrase: [String] = []
    @State private var hasConfirmedBackup = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Create Wallet")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Balance header
                    Color.clear.frame(width: 30)
                }
                .padding()
                
                if !showSeedPhrase {
                    createWalletForm
                } else {
                    seedPhraseView
                }
            }
        }
        .background(Color.deepDark.ignoresSafeArea())
    }
    
    private var createWalletForm: some View {
        VStack(spacing: 24) {
            // Wallet Name Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Wallet Name")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.7))
                
                TextField("My Wallet", text: $walletName)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
            }
            .padding(.horizontal)
            
            // Info Card
            HStack(spacing: 16) {
                Image(systemName: "info.circle.fill")
                    .font(.title3)
                    .foregroundColor(.phantomPurple)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Important")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("You'll be shown a recovery phrase. Write it down and keep it safe. Never share it with anyone.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.phantomPurple.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.phantomPurple.opacity(0.3), lineWidth: 1)
                    )
            )
            .padding(.horizontal)
            
            Spacer()
            
            // Create Button
            Button {
                HapticManager.shared.impact(.medium)
                generateSeedPhrase()
                showSeedPhrase = true
            } label: {
                Text("Create Wallet")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [Color.phantomPurple, Color.phantomGold],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
            }
            .buttonStyle(.plain)
            .disabled(walletName.isEmpty)
            .opacity(walletName.isEmpty ? 0.6 : 1.0)
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
    
    private var seedPhraseView: some View {
        VStack(spacing: 24) {
            Text("Your Recovery Phrase")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Write down these 12 words in order and keep them safe")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Seed Phrase Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Array(seedPhrase.enumerated()), id: \.offset) { index, word in
                    HStack(spacing: 4) {
                        Text("\(index + 1).")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text(word)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.1))
                    )
                }
            }
            .padding(.horizontal)
            
            // Copy Button
            Button {
                UIPasteboard.general.string = seedPhrase.joined(separator: " ")
                HapticManager.shared.notification(.success)
            } label: {
                HStack {
                    Image(systemName: "doc.on.doc")
                    Text("Copy Phrase")
                }
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.phantomPurple)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.phantomPurple, lineWidth: 1.5)
                )
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            
            // Confirmation Toggle
            HStack(spacing: 12) {
                Button {
                    hasConfirmedBackup.toggle()
                    HapticManager.shared.selection()
                } label: {
                    Image(systemName: hasConfirmedBackup ? "checkmark.square.fill" : "square")
                        .font(.title3)
                        .foregroundColor(hasConfirmedBackup ? .phantomPurple : .white.opacity(0.5))
                }
                
                Text("I've written down my recovery phrase")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal)
            
            // Continue Button
            Button {
                HapticManager.shared.impact(.medium)
                isOnboardingComplete = true
            } label: {
                Text("Continue")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [Color.phantomPurple, Color.phantomGold],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
            }
            .buttonStyle(.plain)
            .disabled(!hasConfirmedBackup)
            .opacity(hasConfirmedBackup ? 1.0 : 0.6)
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
    
    private func generateSeedPhrase() {
        let words = ["abandon", "ability", "able", "about", "above", "absent", "absorb", "abstract", "absurd", "abuse", "access", "accident", "account", "accuse", "achieve", "acid", "acoustic", "acquire", "across", "act", "action", "actor", "actual", "adapt", "add", "addict", "address", "adjust", "admit", "adult", "advance", "advice", "aerobic", "affair", "afford", "afraid", "again", "age", "agent", "agree", "ahead", "aim", "air", "airport", "aisle", "alarm", "album", "alcohol", "alert", "alien"]
        seedPhrase = (0..<12).map { _ in words.randomElement()! }
    }
}

// MARK: - Import Wallet View
struct ImportWalletView: View {
    @Binding var isPresented: Bool
    @Binding var isOnboardingComplete: Bool
    @State private var seedPhraseInput: String = ""
    @State private var walletName: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Import Wallet")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 30)
                }
                .padding()
                
                // Wallet Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wallet Name")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextField("My Wallet", text: $walletName)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                }
                .padding(.horizontal)
                
                // Seed Phrase Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recovery Phrase")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextEditor(text: $seedPhraseInput)
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(height: 150)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                        .scrollContentBackground(.hidden)
                }
                .padding(.horizontal)
                
                // Import Button
                Button {
                    HapticManager.shared.impact(.medium)
                    isOnboardingComplete = true
                } label: {
                    Text("Import Wallet")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [Color.phantomPurple, Color.phantomGold],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                        )
                }
                .buttonStyle(.plain)
                .disabled(seedPhraseInput.isEmpty || walletName.isEmpty)
                .opacity(seedPhraseInput.isEmpty || walletName.isEmpty ? 0.6 : 1.0)
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .background(Color.deepDark.ignoresSafeArea())
    }
}

