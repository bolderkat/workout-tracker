//
//  HealthStoreClient.swift
//  WorkoutManager
//
//  Created by Daniel Luo on 9/2/25.
//

import HealthKit

/// Vends a single `HKHealthStore` instance for use throughout the WorkoutManager module,
/// as Apple's guidance is to use only one instance across the app.
/// If we have multiple modules in the future that need access to the `HKHealthStore`, this should be
/// moved to its own module that all the other modules would import.
enum HealthStoreClient {
    static let store = HKHealthStore()
}
