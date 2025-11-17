//
//  ActionButtonsRow.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Action Buttons Row
struct ActionButtonsRow: View {
    let isCardFrozen: Bool
    let showCardDetails: Bool
    let onFreezeTapped: () -> Void
    let onRevealTapped: () -> Void
    let onMoreTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // Freeze Button
            CardActionButton(
                iconName: "snowflake",
                title: isCardFrozen ? "Unfreeze" : "Freeze"
            ) {
                onFreezeTapped()
            }
            .frame(maxWidth: .infinity)
            
            // Reveal Button
            CardActionButton(
                iconName: showCardDetails ? "eye.slash" : "eye",
                title: showCardDetails ? "Hide" : "Reveal"
            ) {
                onRevealTapped()
            }
            .frame(maxWidth: .infinity)
            
            // More Button
            CardActionButton(
                iconName: "ellipsis",
                title: "More"
            ) {
                onMoreTapped()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(width: 340)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - Preview
struct ActionButtonsRow_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonsRow(
            isCardFrozen: false,
            showCardDetails: false,
            onFreezeTapped: { print("Freeze tapped") },
            onRevealTapped: { print("Reveal tapped") },
            onMoreTapped: { print("More tapped") }
        )
        .padding()
        .background(Color.deepDark)
        .preferredColorScheme(.dark)
    }
}
