//
//  MetricsViewModel.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation
import WorkoutManager

@MainActor
@Observable final class MetricsViewModel {
    private let workoutManager: WorkoutManaging

    init(workoutManager: WorkoutManaging) {
        self.workoutManager = workoutManager
    }

    var timelineStartDate: Date {
        workoutManager.builder?.startDate ?? Date()
    }

    var elapsedTime: Double {
        workoutManager.builder?.elapsedTime ?? 0
    }

    var elapsedEnergy: String {
        Measurement(
            value: workoutManager.activeEnergy,
            unit: UnitEnergy.kilocalories
        ).formatted(
            .measurement(
                width: .abbreviated,
                usage: .workout,
                numberFormatStyle: .number.precision(.fractionLength(0))
            )
        )
    }

    var heartRate: String {
        workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm"
    }

    var distance: String {
        Measurement(
            value: workoutManager.distance,
            unit: UnitLength.meters
        ).formatted(
            .measurement(
                width: .abbreviated,
                usage: .road,
            )
        )
    }
}
