//
//  MainTabView.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 15.11.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }.tabViewStyle(.page)           // << enable swipeable pages
        .indexViewStyle(.page(backgroundDisplayMode: .always))  // o
    }
}
