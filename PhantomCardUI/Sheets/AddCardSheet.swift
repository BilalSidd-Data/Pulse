//
//  AddCardSheet.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Add Card Sheet
struct AddCardSheet: View {
    @Binding var isPresented: Bool
    @State private var cardName: String = ""
    @State private var selectedCardType: CardType = .debit
    
    enum CardType: String, CaseIterable {
        case debit = "Debit Card"
        case credit = "Credit Card"
        case virtual = "Virtual Card"
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // iOS 18 drag indicator
            Capsule()
                .fill(.tertiary)
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            
            // Header
            VStack(spacing: 8) {
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.phantomPurple, Color.phantomGold],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce, value: isPresented)
                
                Text("Add New Card")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text("Create a new card for your account")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 8)
            
            // Form
            VStack(spacing: 20) {
                // Card Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Card Name")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    TextField("Enter card name", text: $cardName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 4)
                }
                
                // Card Type
                VStack(alignment: .leading, spacing: 8) {
                    Text("Card Type")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Picker("Card Type", selection: $selectedCardType) {
                        ForEach(CardType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding(.horizontal, 4)
            
            // Action Buttons
            VStack(spacing: 12) {
                Button {
                    HapticManager.shared.impact(.medium)
                    // Add card logic here
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isPresented = false
                    }
                } label: {
                    Text("Add Card")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [Color.phantomPurple, Color.phantomGold],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                        )
                }
                .buttonStyle(.plain)
                .disabled(cardName.isEmpty)
                .opacity(cardName.isEmpty ? 0.6 : 1.0)
                
                Button {
                    HapticManager.shared.selection()
                    isPresented = false
                } label: {
                    Text("Cancel")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.phantomPurple)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 8)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            ZStack {
                Color.deepDark.ignoresSafeArea()
                RoundedRectangle(cornerRadius: 0)
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
        )
    }
}

// MARK: - Preview
struct AddCardSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddCardSheet(isPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}

