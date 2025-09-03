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
    var workoutStartDate: Date? { get }
    var elapsedTime: Double? { get }
    var averageHeartRate: Double { get }
    var heartRate: Double { get }
    var activeEnergy: Double { get }
    var distance: Double { get }
    var completedWorkoutData: WorkoutData? { get }

    func endWorkout()
    func togglePause()
    func requestAuthorization()
}
