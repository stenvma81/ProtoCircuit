//
//  DashboardView.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 16.11.2025.
//

import SwiftUI
import HealthKit

struct DashboardView: View {
    @EnvironmentObject var health: HealthManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    header
                    summaryCards
                    workoutSection
                    notesCard
                    
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
    
    // MARK: - HEADER
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Today")
                .font(.largeTitle.bold())
            
            Text(Date().formatted(date: .long, time: .omitted))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - SUMMARY CARDS (STEPS + ENERGY)
    private var summaryCards: some View {
        HStack(spacing: 16) {
            statCard(title: "Steps", value: "\(health.stepsToday)")
            statCard(title: "Active kcal", value: "\(health.activeEnergyToday)")
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
    
    // MARK: - WORKOUTS
    private var workoutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Workout")
                .font(.headline)
            
            if let workout = health.workoutsToday.first {
                workoutCard(workout)
            } else {
                noWorkoutCard
            }
        }
    }
    
    private var noWorkoutCard: some View {
        HStack {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 30))
                .foregroundColor(.gray.opacity(0.6))
            
            VStack(alignment: .leading) {
                Text("No workouts logged today")
                    .font(.body)
                    .foregroundColor(.secondary)
                Text("Log a workout in Hevy or Apple Fitness")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
    }
    
    private func workoutCard(_ workout: HKWorkout) -> some View {
        HStack {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 30))
            
            VStack(alignment: .leading) {
                Text(workout.workoutActivityType.name)
                    .font(.body.bold())
                
                Text("Duration: \(Int(workout.duration / 60)) min")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("From Hevy / Apple Health")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(16)
    }
    
    // MARK: - NOTES PLACEHOLDER (REAL NOTES WILL COME BACK AFTER CORE DATA FIX)
    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Notes Today")
                .font(.headline)
            
            HStack {
                Image(systemName: "note.text")
                    .font(.system(size: 26))
                Text("Notes integration coming soon")
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(16)
        }
    }
}

// MARK: - EXTENSION TO GET FRIENDLY WORKOUT NAMES
extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .functionalStrengthTraining:
            return "Strength Training"
        case .running:
            return "Running"
        case .walking:
            return "Walking"
        case .cycling:
            return "Cycling"
        case .traditionalStrengthTraining:
            return "Strength Training"
        default:
            return "Workout"
        }
    }
}
