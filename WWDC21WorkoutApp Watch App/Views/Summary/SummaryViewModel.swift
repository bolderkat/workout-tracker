//
//  SummaryViewModel.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import HealthKit // refactor so we don't need to access the healthstore from here
import Foundation
import WorkoutManager

@MainActor
@Observable final class SummaryViewModel {
    private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    private let workoutManager: WorkoutManaging

    init(workoutManager: WorkoutManaging) {
        self.workoutManager = workoutManager
    }

    var completedWorkoutData: WorkoutData? {
        workoutManager.completedWorkoutData
    }

    var totalTime: String {
        durationFormatter.string(from: completedWorkoutData?.totalTime ?? 0.0) ?? ""
    }

    var totalDistance: String {
        return Measurement(
            value: completedWorkoutData?.totalDistance ?? 0.0,
            unit: UnitLength.meters
        ).formatted(
            .measurement(
                width: .abbreviated,
                usage: .road
            )
        )
    }

    var totalEnergy: String {
        Measurement(
            value: completedWorkoutData?.activeEnergyBurned ?? 0.0,
            unit: UnitEnergy.kilocalories
        ).formatted(
            .measurement(
                width: .abbreviated,
                usage: .workout,
                numberFormatStyle: .number.precision(.fractionLength(0))
            )
        )
    }

    var averageHeartRate: String {
        workoutManager.averageHeartRate
            .formatted(.number.precision(.fractionLength(0)))
        + " bpm"
    }
}
