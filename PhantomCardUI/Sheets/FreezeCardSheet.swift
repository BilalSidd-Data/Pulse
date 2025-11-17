//
//  FreezeCardSheet.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Freeze Card Sheet
struct FreezeCardSheet: View {
    @Binding var isPresented: Bool
    @Binding var isCardFrozen: Bool

    var body: some View {
        VStack(spacing: 24) {
            // iOS 18 drag indicator
            Capsule()
                .fill(.tertiary)
                .frame(width: 36, height: 5)
                .padding(.top, 8)

            // Content
            VStack(spacing: 16) {
                // Icon with iOS 18 styling
                Image(systemName: "snowflake")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.phantomPurple)
                    .symbolEffect(.bounce, value: isPresented)
                    .padding(.bottom, 8)
                
                // Title
                Text(isCardFrozen ? "Unfreeze Card?" : "Freeze Card?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                // Description with proper typography
                VStack(spacing: 12) {
                    Text("This action will disable your card temporarily. However, recurring transactions such as those on Netflix and on other merchants with which you have saved your card details will continue to be processed.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("If your debit card has been lost, compromised or stolen, please block your card immediately and order a replacement (reissuance fees will apply).")
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 4)
            }
            .padding(.top, 8)

            // iOS 18 style buttons
            VStack(spacing: 12) {
                // Primary button
                Button {
                    HapticManager.shared.impact(.medium)
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isCardFrozen.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isPresented = false
                    }
                } label: {
                    Text(isCardFrozen ? "Unfreeze Card" : "Freeze Card")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.phantomPurple, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)

                // Secondary button
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
        .sheetBackground() // iOS 18 HIG background
    }
}

struct FreezeCardSheet_Previews: PreviewProvider {
    static var previews: some View {
        FreezeCardSheet(isPresented: .constant(true), isCardFrozen: .constant(false))
            .preferredColorScheme(.dark)
    }
}
