//
//  RealWorkoutManager.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation
import HealthKit

@Observable class RealWorkoutManager: NSObject, WorkoutManager {
    var selectedWorkout: WorkoutType? {
        didSet {
            guard let selectedWorkout else { return }
            startWorkout(of: selectedWorkout)
        }
    }

    var isShowingSummaryView: Bool = false {
        didSet {
            if !isShowingSummaryView {
                resetWorkout()
            }
        }
    }

    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?

    // MARK: - State machine

    var isRunning = false

    func togglePause() {
        if isRunning == true {
            pause()
        } else {
            resume()
        }
    }

    private func pause() {
        session?.pause()
    }

    private func resume() {
        session?.resume()
    }

    func endWorkout() {
        session?.end()
        isShowingSummaryView = true
    }

    // MARK: - HealthKit

    // MARK: Workout Metrics

    var averageHeartRate: Double = 0
    var heartRate: Double = 0
    var activeEnergy: Double = 0
    var distance: Double = 0
    var workout: HKWorkout?

    @MainActor
    private func updateFor(_ statistics: HKStatistics?) {
        guard let statistics else { return }

        switch statistics.quantityType {
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0

        case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
            let energyUnit = HKUnit.kilocalorie()
            activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0

        case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
            let distanceUnit = HKUnit.meter()
            distance = statistics.sumQuantity()?.doubleValue(for: distanceUnit) ?? 0

        case HKQuantityType(.distanceCycling):
            let distanceUnit = HKUnit.meter()
            distance = statistics.sumQuantity()?.doubleValue(for: distanceUnit) ?? 0

        default:
            return
        }
    }

    // main actor??
    private func resetWorkout() {
        selectedWorkout = nil
        builder = nil
        session = nil
        workout = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }

    /// Request authorization to access HealthKit.
    func requestAuthorization() {
        // Types to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        // The quantity types to read from the heatlh store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType(),
        ]

        healthStore.requestAuthorization(
            toShare: typesToShare,
            read: typesToRead
        ) { success, error in
            // handle error
        }
    }

    private func startWorkout(of workoutType: WorkoutType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType.asHKWorkoutActivityType
        configuration.locationType = .outdoor

        do {
            session = try HKWorkoutSession(
                healthStore: healthStore,
                configuration: configuration
            )

            builder = session?.associatedWorkoutBuilder()
        } catch {
            // we would handle errors here.
            return
        }

        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )

        session?.delegate = self
        builder?.delegate = self

        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { success, error in
            // workout started
        }
    }
}

// MARK: - HKWorkoutSessionDelegate

extension RealWorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date
    ) {
        DispatchQueue.main.async { [weak self] in
            if toState == .running {
                self?.isRunning = true
            } else {
                self?.isRunning = false
            }
        }

        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { [weak self] success, error in
                // Once we finish collection, we finish the workout which saves it to the HealthStore.
                self?.builder?.finishWorkout { workout, error in
                    DispatchQueue.main.async { [weak self] in
                        self?.workout = workout
                    }
                }
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: any Error) {
        // present failure UI
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate

extension RealWorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // unimplemented
    }

    func workoutBuilder(
        _ workoutBuilder: HKLiveWorkoutBuilder,
        didCollectDataOf collectedTypes: Set<HKSampleType>
    ) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update published values.
            Task {
                await updateFor(statistics)
            }
        }
    }
}
