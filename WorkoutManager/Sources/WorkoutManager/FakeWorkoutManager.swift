//
//  FakeWorkoutManager.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation
import HealthKit

@MainActor
@Observable public class FakeWorkoutManager: WorkoutManaging {
    public var selectedWorkout: WorkoutType?
    public var isShowingSummaryView: Bool
    public var isRunning: Bool
    public var averageHeartRate: Double
    public var heartRate: Double
    public var activeEnergy: Double
    public var distance: Double
    public var builder: HKLiveWorkoutBuilder?
    public var completedWorkoutData: WorkoutData?
    public var healthStore: HKHealthStore = HKHealthStore()

    public var onEndWorkout: (() -> Void)?
    public func endWorkout() {
        onEndWorkout?()
    }

    public var onTogglePause: (() -> Void)?
    public func togglePause() {
        onTogglePause?()
    }

    public var onRequestAuthorization: (() -> Void)?
    public func requestAuthorization() {
        onRequestAuthorization?()
    }

    public init(
        selectedWorkout: WorkoutType? = nil,
        isShowingSummaryView: Bool = false,
        isRunning: Bool = false,
        averageHeartRate: Double = 0,
        heartRate: Double = 0,
        activeEnergy: Double = 0,
        distance: Double = 0,
        builder: HKLiveWorkoutBuilder? = nil,
        completedWorkoutData: WorkoutData? = nil,
        healthStore: HKHealthStore = HKHealthStore(),
        onEndWorkout: (() -> Void)? = nil,
        onTogglePause: (() -> Void)? = nil,
        onRequestAuthorization: (() -> Void)? = nil
    ) {
        self.selectedWorkout = selectedWorkout
        self.isShowingSummaryView = isShowingSummaryView
        self.isRunning = isRunning
        self.averageHeartRate = averageHeartRate
        self.heartRate = heartRate
        self.activeEnergy = activeEnergy
        self.distance = distance
        self.builder = builder
        self.completedWorkoutData = completedWorkoutData
        self.healthStore = healthStore
        self.onEndWorkout = onEndWorkout
        self.onTogglePause = onTogglePause
        self.onRequestAuthorization = onRequestAuthorization
    }
}
