//
//  StartViewModel.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import HealthKit
import Foundation

@Observable final class StartViewModel {
    private var workoutManager: WorkoutManager

    let workoutTypes: [HKWorkoutActivityType] = [
        .cycling,
        .running,
        .walking
    ]

    init(workoutManager: WorkoutManager) {
        self.workoutManager = workoutManager
    }

    var selectedWorkout: HKWorkoutActivityType? {
        get {
            workoutManager.selectedWorkout
        }
        set {
            workoutManager.selectedWorkout = newValue
        }
    }

    func requestAuthorization() {
        workoutManager.requestAuthorization()
    }
}
