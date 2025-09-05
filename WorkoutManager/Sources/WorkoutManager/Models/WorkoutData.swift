//
//  WorkoutData.swift
//  WorkoutManager
//
//  Created by Daniel Luo on 9/2/25.
//

import Foundation

/// Represents the basic info needed to display a summary for a completed workout.
public struct WorkoutData: Sendable, Equatable {
    public let totalTime: TimeInterval
    /// Distance traveled during the workout, in meters.
    public let totalDistance: Double
    /// Active energy burned during the workout, in kilocalories.
    public let activeEnergyBurned: Double

    public init(
        totalTime: TimeInterval,
        totalDistance: Double,
        activeEnergyBurned: Double
    ) {
        self.totalTime = totalTime
        self.totalDistance = totalDistance
        self.activeEnergyBurned = activeEnergyBurned
    }
}
