//
//  AddTokenView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Add Token View
struct AddTokenView: View {
    @Binding var isPresented: Bool
    @Binding var tokens: [Token]
    let allTokens: [Token]
    @State private var searchText: String = ""
    
    private var availableTokens: [Token] {
        let ownedTokenIds = Set(tokens.map { $0.id })
        let filtered = allTokens.filter { !ownedTokenIds.contains($0.id) }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.symbol.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))
                    
                    TextField("Search tokens...", text: $searchText)
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                )
                .padding()
                
                // Token List
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(availableTokens) { token in
                            Button {
                                addToken(token)
                            } label: {
                                TokenSelectionRow(
                                    token: token,
                                    isSelected: false
                                )
                            }
                            .buttonStyle(.plain)
                            
                            if token.id != availableTokens.last?.id {
                                Divider()
                                    .padding(.leading, 60)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
                    .padding(.horizontal)
                }
            }
            .background(Color.deepDark.ignoresSafeArea())
            .navigationTitle("Add Token")
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
    
    private func addToken(_ token: Token) {
        HapticManager.shared.selection()
        tokens.append(token)
        isPresented = false
    }
}

