//
//  MoreOptionRow.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - More Option Row Component (iOS 18 HIG Compliant)
struct MoreOptionRow: View {
    let icon: String
    let title: String
    let isToggle: Bool
    @Binding var isOn: Bool
    var action: (() -> Void)? = nil
    
    var body: some View {
        Group {
            if isToggle {
                toggleRowView
            } else {
                navigationRowView
            }
        }
    }
    
    // MARK: - Toggle Row View
    private var toggleRowView: some View {
        HStack(spacing: 16) {
            // Icon with iOS 18 style
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(Color.phantomPurple)
                .frame(width: 32, height: 32)
            
            // Title
            Text(title)
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
            
            // iOS 18 style toggle
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color.phantomPurple))
                .labelsHidden()
                .onChange(of: isOn) { oldValue, newValue in
                    HapticManager.shared.selection()
                }
        }
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
    
    // MARK: - Navigation Row View
    private var navigationRowView: some View {
        Button(action: {
            HapticManager.shared.selection()
            action?()
        }) {
            HStack(spacing: 16) {
                // Icon with iOS 18 style
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.phantomPurple)
                    .frame(width: 32, height: 32)
                
                // Title
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                // iOS 18 chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
struct MoreOptionRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MoreOptionRow(
                icon: "network",
                title: "Online Payments",
                isToggle: true,
                isOn: .constant(true)
            )
            
            MoreOptionRow(
                icon: "lock.rotation",
                title: "Change PIN",
                isToggle: false,
                isOn: .constant(false)
            ) {
                print("PIN tapped")
            }
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
