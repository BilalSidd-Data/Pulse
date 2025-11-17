//
//  ContentView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI
import UIKit

// MARK: - Main Content View
struct ContentView: View {
    // MARK: - State Properties
    @State private var isFreezeSheetPresented = false
    @State private var isCardFrozen = false
    @State private var showCardDetails = false
    @State private var isMoreOptionsSheetPresented = false
    @State private var isAddCardSheetPresented = false
    @State private var isNotificationsSheetPresented = false
    
    // More Options State
    @State private var onlinePaymentsEnabled = true
    @State private var tapAndPayEnabled = true
    @State private var spendingControlEnabled = false
    @State private var chipAndPinEnabled = true
    
    // Notifications State
    @State private var notifications: [NotificationItem] = [
        NotificationItem(
            title: "Transaction Completed",
            message: "Payment of €125.50 to Amazon Inc. was successful",
            time: "2 hours ago",
            icon: "checkmark.circle.fill",
            isRead: false,
            type: .transaction
        ),
        NotificationItem(
            title: "Daily Limit Reached",
            message: "You've used 75% of your daily spending limit",
            time: "5 hours ago",
            icon: "exclamationmark.triangle.fill",
            isRead: false,
            type: .limit
        ),
        NotificationItem(
            title: "Card Unfrozen",
            message: "Your card has been successfully unfrozen",
            time: "Yesterday",
            icon: "snowflake",
            isRead: true,
            type: .security
        ),
        NotificationItem(
            title: "Exchange Rate Updated",
            message: "New SOL/EUR rate: €150.29",
            time: "2 days ago",
            icon: "arrow.left.arrow.right.circle.fill",
            isRead: true,
            type: .general
        )
    ]

    // MARK: - Body
    var body: some View {
        scrollableContent
            .sheet(isPresented: $isFreezeSheetPresented) {
                freezeSheet
            }
            .sheet(isPresented: $isMoreOptionsSheetPresented) {
                moreOptionsSheet
            }
            .sheet(isPresented: $isAddCardSheetPresented) {
                addCardSheet
            }
            .sheet(isPresented: $isNotificationsSheetPresented) {
                notificationsSheet
            }
    }
    
    // MARK: - Scrollable Content
    private var scrollableContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HeaderView(
                    onAddTapped: handleAddTapped,
                    onNotificationsTapped: handleNotificationsTapped,
                    hasUnreadNotifications: notifications.contains { !$0.isRead }
                )
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Sticky Card with Animation
                GeometryReader { geometry in
                    let minY = geometry.frame(in: .global).minY
                    let startPosition: CGFloat = 200
                    let progress = min(max((startPosition - minY) / 300, 0), 1)
                    
                    HStack {
                        Spacer()
                        StickyCardView(
                            progress: progress,
                            isRevealed: showCardDetails,
                            onCopy: copyCardNumber
                        )
                        Spacer()
                    }
                }
                .frame(height: 520)
                
                // Action Buttons Row
                ActionButtonsRow(
                    isCardFrozen: isCardFrozen,
                    showCardDetails: showCardDetails,
                    onFreezeTapped: handleFreezeTapped,
                    onRevealTapped: handleRevealTapped,
                    onMoreTapped: handleMoreTapped
                )
                
                // Card Limits Section
                CardLimitsSection()
                
                // Transaction History Section
                TransactionHistoryView()
                
                Spacer(minLength: 120)
            }
            .padding(.top, 8)
            .padding(.horizontal, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .scrollIndicators(.hidden)
        .background(Color.deepDark.edgesIgnoringSafeArea(.all))
        .onAppear {
            // Disable bounce using UIKit
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                disableBounceInScrollViews()
            }
        }
    }
    
    // MARK: - Freeze Sheet
    private var freezeSheet: some View {
        FreezeCardSheet(isPresented: $isFreezeSheetPresented, isCardFrozen: $isCardFrozen)
            .presentationDetents([.fraction(0.6)])
            .presentationDragIndicator(.visible)
    }
    
    // MARK: - More Options Sheet
    private var moreOptionsSheet: some View {
        MoreOptionsSheet(
            isPresented: $isMoreOptionsSheetPresented,
            onlinePaymentsEnabled: $onlinePaymentsEnabled,
            tapAndPayEnabled: $tapAndPayEnabled,
            spendingControlEnabled: $spendingControlEnabled,
            chipAndPinEnabled: $chipAndPinEnabled
        )
        .presentationDetents([.fraction(0.65)])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Add Card Sheet
    private var addCardSheet: some View {
        AddCardSheet(isPresented: $isAddCardSheetPresented)
            .presentationDetents([.fraction(0.7)])
            .presentationDragIndicator(.visible)
    }
    
    // MARK: - Notifications Sheet
    private var notificationsSheet: some View {
        NotificationsSheet(
            isPresented: $isNotificationsSheetPresented,
            notifications: $notifications
        )
        .presentationDetents([.fraction(0.75), .large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Actions
    private func handleFreezeTapped() {
        isFreezeSheetPresented = true
    }
    
    private func handleRevealTapped() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showCardDetails.toggle()
        }
    }
    
    private func handleMoreTapped() {
        isMoreOptionsSheetPresented = true
    }
    
    private func handleAddTapped() {
        isAddCardSheetPresented = true
    }
    
    private func handleNotificationsTapped() {
        isNotificationsSheetPresented = true
    }
    
    private func copyCardNumber() {
        UIPasteboard.general.string = "4567 8978 7553"
        HapticManager.shared.notification(.success)
    }
    
    // MARK: - Disable Bounce Helper
    private func disableBounceInScrollViews() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        findAndDisableBounce(in: window)
    }
    
    private func findAndDisableBounce(in view: UIView) {
        if let scrollView = view as? UIScrollView {
            scrollView.bounces = false
            scrollView.alwaysBounceVertical = false
            scrollView.alwaysBounceHorizontal = false
        }
        for subview in view.subviews {
            findAndDisableBounce(in: subview)
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
