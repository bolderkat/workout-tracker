//
//  StartViewModel.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation
import WorkoutManager

@MainActor
@Observable final class StartViewModel {
    private var workoutManager: WorkoutManaging

    let workoutTypes: [WorkoutType] = [
        .cycling,
        .running,
        .walking
    ]

    init(workoutManager: WorkoutManaging) {
        self.workoutManager = workoutManager
    }

    var selectedWorkout: WorkoutType? {
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
