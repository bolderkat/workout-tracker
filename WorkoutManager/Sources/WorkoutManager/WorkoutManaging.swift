//
//  WorkoutManaging.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/29/25.
//

import Foundation
import HealthKit

@MainActor
public protocol WorkoutManaging {
    var selectedWorkout: WorkoutType? { get set }
    var isShowingSummaryView: Bool { get set }
    var isRunning: Bool { get }
    var builder: HKLiveWorkoutBuilder? { get } // TODO: expose elapsed time and start date instead of builder
    var averageHeartRate: Double { get }
    var heartRate: Double { get }
    var activeEnergy: Double { get }
    var distance: Double { get }
    var workout: HKWorkout? { get } // TODO: expose desired metrics instead of workout
    var healthStore: HKHealthStore { get } // TODO: vend ActivityRingsView instead of exposing HKHealthStore

    func endWorkout()
    func togglePause()
    func requestAuthorization()
}
