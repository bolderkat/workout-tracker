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
    public var didUserEndCurrentWorkout: Bool
    public var isWorkoutRunning: Bool
    public var averageHeartRate: Double
    public var heartRate: Double
    public var activeEnergy: Double
    public var distance: Double
    public var workoutStartDate: Date?
    public var elapsedTime: Double?
    public var completedWorkoutData: WorkoutData?

    public var onEndWorkout: (() -> Void)?
    public func endWorkout() {
        onEndWorkout?()
    }

    public var onResetWorkoutData: (() -> Void)?
    public func resetWorkoutData() {
        onResetWorkoutData?()
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
        workoutStartDate: Date? = nil,
        elapsedTime: Double? = nil,
        averageHeartRate: Double = 0,
        heartRate: Double = 0,
        activeEnergy: Double = 0,
        distance: Double = 0,
        completedWorkoutData: WorkoutData? = nil,
        onEndWorkout: (() -> Void)? = nil,
        onResetWorkoutData: (() -> Void)? = nil,
        onTogglePause: (() -> Void)? = nil,
        onRequestAuthorization: (() -> Void)? = nil
    ) {
        self.selectedWorkout = selectedWorkout
        self.didUserEndCurrentWorkout = isShowingSummaryView
        self.isWorkoutRunning = isRunning
        self.workoutStartDate = workoutStartDate
        self.elapsedTime = elapsedTime
        self.averageHeartRate = averageHeartRate
        self.heartRate = heartRate
        self.activeEnergy = activeEnergy
        self.distance = distance
        self.completedWorkoutData = completedWorkoutData
        self.onEndWorkout = onEndWorkout
        self.onResetWorkoutData = onResetWorkoutData
        self.onTogglePause = onTogglePause
        self.onRequestAuthorization = onRequestAuthorization
    }
}
