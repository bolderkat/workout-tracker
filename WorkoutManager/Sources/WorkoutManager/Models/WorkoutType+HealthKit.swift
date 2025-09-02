//
//  WorkoutType+HealthKit.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import HealthKit

public extension WorkoutType {
    var asHKWorkoutActivityType: HKWorkoutActivityType {
        switch self {
        case .running:
            .running
        case .cycling:
            .cycling
        case .walking:
            .walking
        }
    }
}
