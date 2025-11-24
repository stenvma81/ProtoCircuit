//
//  MainTabView.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 15.11.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home
    @State private var showingNewNote = false

    var body: some View {
        ZStack(alignment: .bottom) {

            // Main content changes depending on selected tab
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .calendar:
                    CalendarView()
                case .notes:
                    NotesListView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard)  // prevent jumps

            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab) {
                showingNewNote = true       // FAB action
            }
        }
        .sheet(isPresented: $showingNewNote) {
            NewNoteView()
        }
    }
}
