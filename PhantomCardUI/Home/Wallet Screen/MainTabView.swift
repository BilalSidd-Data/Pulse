//
//  MainTabView.swift
//  PULSE
//
//  Created by Muhammad Bilal Siddiqui on 08/11/25.
//

import SwiftUI
import Combine

// MARK: - Tab Item
enum TabItem: Int, CaseIterable {
    case home = 0
    case card = 1
    case swap = 2
    case activity = 3
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .card: return "creditcard.fill"
        case .swap: return "arrow.up.arrow.down"
        case .activity: return "clock.fill"
        }
    }
    
    var label: String {
        switch self {
        case .home: return "Home"
        case .card: return "Card"
        case .swap: return "Swap"
        case .activity: return "Activity"
        }
    }
}

// MARK: - Tab Selection Manager
class TabSelectionManager: ObservableObject {
    @Published var selectedTab: TabItem = .home
}

// MARK: - Main Tab View (Native with Liquid Glass Effect)
struct MainTabView: View {
    @StateObject private var tabManager = TabSelectionManager()
    
    var body: some View {
        TabView(selection: $tabManager.selectedTab) {
            HomeView()
                .environmentObject(tabManager)
                .tabItem {
                    Label(TabItem.home.label, systemImage: TabItem.home.icon)
                }
                .tag(TabItem.home)
            
            CardTabView()
                .tabItem {
                    Label(TabItem.card.label, systemImage: TabItem.card.icon)
                }
                .tag(TabItem.card)
            
            SwapView()
                .tabItem {
                    Label(TabItem.swap.label, systemImage: TabItem.swap.icon)
                }
                .tag(TabItem.swap)
            
            ActivityView()
                .tabItem {
                    Label(TabItem.activity.label, systemImage: TabItem.activity.icon)
                }
                .tag(TabItem.activity)
        }
        .onChange(of: tabManager.selectedTab) { oldValue, newValue in
            HapticManager.shared.selection()
        }
        .liquidGlassTabBar()
    }
}

// MARK: - Card Tab View (Current ContentView)
struct CardTabView: View {
    var body: some View {
        ContentView()
    }
}

