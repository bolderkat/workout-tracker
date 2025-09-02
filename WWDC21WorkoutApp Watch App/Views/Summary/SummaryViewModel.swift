//
//  SummaryViewModel.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import HealthKit // can refactor WorkoutManaging so we don't need to look at the HKWorkout directly, but we would still need this import in order to vend a HKHealthStore from here.
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

    var savedWorkout: HKWorkout? {
        workoutManager.workout
    }

    var totalTime: String {
        durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? ""
    }

    var totalDistance: String {
        let distanceStatistics: HKStatistics? = switch workoutManager.workout?.workoutActivityType {
        case .running, .walking:
            workoutManager.workout?.statistics(for: HKQuantityType(.distanceWalkingRunning))

        case .cycling:
            workoutManager.workout?.statistics(for: HKQuantityType(.distanceCycling))

        default:
            // Workout type not supported by this app.
            nil
        }

        return Measurement(
            value: distanceStatistics?.sumQuantity()?.doubleValue(for: .meter()) ?? 0.0,
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
            value: workoutManager.workout?.statistics(for: HKQuantityType(.activeEnergyBurned))?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0.0,
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

    var healthStore: HKHealthStore {
        workoutManager.healthStore
    }
}
