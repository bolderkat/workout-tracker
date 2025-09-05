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
    var isWorkoutRunning: Bool { get }
    var didUserEndCurrentWorkout: Bool { get set }
    var workoutStartDate: Date? { get }
    var elapsedTime: Double? { get }
    var averageHeartRate: Double { get }
    var heartRate: Double { get }
    var activeEnergy: Double { get }
    var distance: Double { get }
    var completedWorkoutData: WorkoutData? { get }

    func endWorkout()
    func resetWorkoutData()
    func togglePause()
    func requestAuthorization()
}
