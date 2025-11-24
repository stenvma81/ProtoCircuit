//
//  CustomTabBar.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 24.11.2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    var onActionButton: () -> Void

    var body: some View {
        ZStack {
            // Background bar
            HStack {
                tabButton(.home, "house.fill")
                tabButton(.calendar, "calendar")
                
                Spacer().frame(width: 70) // space for FAB
                
                tabButton(.notes, "note.text")
                tabButton(.settings, "gear")
            }
            .padding(.horizontal, 25)
            .padding(.top, 6)
            .padding(.bottom, 10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(radius: 5)

            // Floating Action Button
            Button(action: onActionButton) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.blue)
                    .shadow(color: .black.opacity(0.25), radius: 5)
            }
            .offset(y: -30)
        }
        .frame(height: 72)
    }

    @ViewBuilder
    private func tabButton(_ tab: AppTab, _ systemImage: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                Text(label(for: tab))
                    .font(.caption2)
            }
            .foregroundColor(selectedTab == tab ? .blue : .gray)
            .frame(maxWidth: .infinity)
        }
    }

    private func label(for tab: AppTab) -> String {
        switch tab {
        case .home: return "Home"
        case .calendar: return "Calendar"
        case .notes: return "Notes"
        case .settings: return "Settings"
        }
    }
}
