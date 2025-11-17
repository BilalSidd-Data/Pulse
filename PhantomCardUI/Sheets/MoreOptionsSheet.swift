//
//  MoreOptionsSheet.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - More Options Sheet (iOS 18 HIG Compliant)
struct MoreOptionsSheet: View {
    @Binding var isPresented: Bool
    @Binding var onlinePaymentsEnabled: Bool
    @Binding var tapAndPayEnabled: Bool
    @Binding var spendingControlEnabled: Bool
    @Binding var chipAndPinEnabled: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // iOS 18 drag indicator
            Capsule()
                .fill(.tertiary)
                .frame(width: 36, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 20)
            
            // Title Header
            sheetHeader
            
            // Options List
            ScrollView {
                optionsList
            }
            
            Spacer(minLength: 0)
        }
        .sheetBackground() // iOS 18 HIG background
    }
    
    // MARK: - Sheet Header
    private var sheetHeader: some View {
        Text("More Options")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
    }
    
    // MARK: - Options List
    private var optionsList: some View {
        VStack(spacing: 0) {
            MoreOptionRow(
                icon: "network",
                title: "Online Payments",
                isToggle: true,
                isOn: $onlinePaymentsEnabled
            )
            
            Divider()
                .padding(.leading, 60)
            
            MoreOptionRow(
                icon: "wave.3.right",
                title: "Tap and Pay",
                isToggle: true,
                isOn: $tapAndPayEnabled
            )
            
            Divider()
                .padding(.leading, 60)
            
            MoreOptionRow(
                icon: "chart.bar.fill",
                title: "Spending Control",
                isToggle: true,
                isOn: $spendingControlEnabled
            )
            
            Divider()
                .padding(.leading, 60)
            
            MoreOptionRow(
                icon: "creditcard.and.123",
                title: "Chip and Pin",
                isToggle: true,
                isOn: $chipAndPinEnabled
            )
            
            Divider()
                .padding(.leading, 60)
            
            MoreOptionRow(
                icon: "lock.rotation",
                title: "Change PIN",
                isToggle: false,
                isOn: .constant(false)
            ) {
                handlePinChange()
            }
        }
        .padding(.horizontal, 20)
        .groupedListStyle() // iOS 18 HIG material
    }
    
    // MARK: - Actions
    private func handlePinChange() {
        HapticManager.shared.selection()
        print("Change PIN tapped")
    }
}

// MARK: - Preview
struct MoreOptionsSheet_Previews: PreviewProvider {
    static var previews: some View {
        MoreOptionsSheet(
            isPresented: .constant(true),
            onlinePaymentsEnabled: .constant(true),
            tapAndPayEnabled: .constant(true),
            spendingControlEnabled: .constant(false),
            chipAndPinEnabled: .constant(true)
        )
        .preferredColorScheme(.dark)
    }
}
