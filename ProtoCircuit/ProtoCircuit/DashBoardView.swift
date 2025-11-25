//
//  DashBoardView.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 25.11.2025.
//

import SwiftUI

struct DashboardView: View {
    // Mock data placeholders
    @State private var stepsToday = 8423
    @State private var activeEnergy = 527
    @State private var hevyWorkoutToday = "Upper Body Push"
    @State private var notesToday = 2
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    header
                    
                    summaryCards
                    
                    recentWorkoutCard
                    
                    notesCard
                    
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Today")
                .font(.largeTitle.bold())
            Text(Date().formatted(date: .long, time: .omitted))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Summary Stack
    private var summaryCards: some View {
        HStack(spacing: 16) {
            statCard(title: "Steps", value: "\(stepsToday)")
            statCard(title: "Active kcal", value: "\(activeEnergy)")
        }
    }
    
    private func statCard(title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title.bold())
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
    }
    
    // MARK: - Hevy workout
    private var recentWorkoutCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Workout")
                .font(.headline)
            
            HStack {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 30))
                VStack(alignment: .leading) {
                    Text(hevyWorkoutToday)
                        .font(.body.bold())
                    Text("Logged in Hevy")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)
        }
    }
    
    // MARK: - Notes
    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Notes Today")
                .font(.headline)
            
            HStack {
                Image(systemName: "note.text")
                    .font(.system(size: 26))
                Text("\(notesToday) notes")
                    .font(.body)
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)
        }
    }
}
