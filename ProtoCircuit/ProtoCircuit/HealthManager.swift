//
//  HealthManager.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 25.11.2025.
//

import Foundation
import HealthKit

@MainActor
class HealthManager: ObservableObject {
    static let shared = HealthManager()
    private let healthStore = HKHealthStore()
    
    @Published var stepsToday: Int = 0
    @Published var activeEnergyToday: Int = 0
    @Published var workoutsToday: [HKWorkout] = []
    
    private init() { }
    
    // MARK: - Request Authorization
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType()
        ]
        
        try await healthStore.requestAuthorization(toShare: [], read: readTypes)
    }
    
    // MARK: - Fetch Today’s Steps
    func fetchStepsToday() async {
        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: [])
        
        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result,
                  let sum = result.sumQuantity() else { return }
            
            let value = Int(sum.doubleValue(for: .count()))
            Task { @MainActor in
                self.stepsToday = value
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Fetch Today’s Active Energy
    func fetchActiveEnergyToday() async {
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: [])
        
        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            
            guard let result = result,
                  let sum = result.sumQuantity() else { return }
            
            let kcal = Int(sum.doubleValue(for: .kilocalorie()))
            Task { @MainActor in
                self.activeEnergyToday = kcal
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Fetch Workouts (Hevy Included)
    func fetchWorkoutsToday() async {
        let start = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: start, end: Date(), options: [])
        
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: nil) { _, samples, _ in
            
            guard let workouts = samples as? [HKWorkout] else { return }
            
            Task { @MainActor in
                self.workoutsToday = workouts
            }
        }
        
        healthStore.execute(query)
    }
}
