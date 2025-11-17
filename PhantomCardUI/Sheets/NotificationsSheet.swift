//
//  NotificationsSheet.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI

// MARK: - Notification Item
struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let time: String
    let icon: String
    var isRead: Bool
    let type: NotificationType
    
    enum NotificationType {
        case transaction
        case security
        case limit
        case general
    }
}

// MARK: - Notifications Sheet
struct NotificationsSheet: View {
    @Binding var isPresented: Bool
    @Binding var notifications: [NotificationItem]
    
    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    private func markAsRead(at index: Int) {
        guard index < notifications.count else { return }
        var updatedNotifications = notifications
        updatedNotifications[index].isRead = true
        notifications = updatedNotifications
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // iOS 18 drag indicator
            Capsule()
                .fill(.tertiary)
                .frame(width: 36, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 20)
            
            // Header
            HStack {
                Text("Notifications")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                if unreadCount > 0 {
                    Text("\(unreadCount) New")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.phantomPurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.phantomPurple.opacity(0.15))
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            
            // Notifications List
            if notifications.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bell.slash.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.tertiary)
                    
                    Text("No Notifications")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    
                    Text("You're all caught up!")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(notifications.enumerated()), id: \.element.id) { index, notification in
                            NotificationRow(
                                notification: notification,
                                onTap: {
                                    markAsRead(at: index)
                                }
                            )
                            
                            if index < notifications.count - 1 {
                                Divider()
                                    .padding(.leading, 60)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
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

// MARK: - Notification Row
struct NotificationRow: View {
    let notification: NotificationItem
    let onTap: () -> Void
    
    var iconColor: Color {
        switch notification.type {
        case .transaction:
            return .green
        case .security:
            return .blue
        case .limit:
            return .orange
        case .general:
            return .phantomPurple
        }
    }
    
    var body: some View {
        Button {
            HapticManager.shared.selection()
            onTap()
        } label: {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: notification.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(notification.title)
                            .font(.body)
                            .fontWeight(notification.isRead ? .regular : .semibold)
                            .foregroundStyle(.primary)
                        
                        if !notification.isRead {
                            Circle()
                                .fill(Color.phantomPurple)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Text(notification.message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    
                    Text(notification.time)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .opacity(notification.isRead ? 0.7 : 1.0)
    }
}

// MARK: - Preview
struct NotificationsSheet_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSheet(
            isPresented: .constant(true),
            notifications: .constant([
                NotificationItem(
                    title: "Transaction Completed",
                    message: "Payment of €125.50 to Amazon Inc. was successful",
                    time: "2 hours ago",
                    icon: "checkmark.circle.fill",
                    isRead: false,
                    type: .transaction
                )
            ])
        )
        .preferredColorScheme(.dark)
    }
}

