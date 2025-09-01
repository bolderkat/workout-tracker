//
//  FakeWorkoutManager.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation
import HealthKit

@Observable class FakeWorkoutManager: WorkoutManager {
    var selectedWorkout: WorkoutType?
    var isShowingSummaryView: Bool = false
    var isRunning = false
    var averageHeartRate: Double = 0
    var heartRate: Double = 0
    var activeEnergy: Double = 0
    var distance: Double = 0
    var builder: HKLiveWorkoutBuilder?
    var workout: HKWorkout?
    var healthStore: HKHealthStore = HKHealthStore()

    var onEndWorkout: (() -> Void)?
    func endWorkout() {
        onEndWorkout?()
    }

    var onTogglePause: (() -> Void)?
    func togglePause() {
        onTogglePause?()
    }

    var onRequestAuthorization: (() -> Void)?
    func requestAuthorization() {
        onRequestAuthorization?()
    }
}
