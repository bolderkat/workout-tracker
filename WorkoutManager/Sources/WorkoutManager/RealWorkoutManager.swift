//
//  RealWorkoutManager.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation
import HealthKit

@MainActor
@Observable public class RealWorkoutManager: NSObject, WorkoutManaging {
    public var selectedWorkout: WorkoutType? {
        didSet {
            guard let selectedWorkout else { return }
            Task { @MainActor in
                await startWorkout(of: selectedWorkout)
            }
        }
    }

    public var didUserEndCurrentWorkout: Bool = false

    public private(set) var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    // MARK: - State machine

    public var isWorkoutRunning = false

    public func togglePause() {
        if isWorkoutRunning == true {
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

    public func endWorkout() {
        session?.end()
        didUserEndCurrentWorkout = true
    }

    public func resetWorkoutData() {
        selectedWorkout = nil
        builder = nil
        session = nil
        completedWorkoutData = nil
        didUserEndCurrentWorkout = false
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }

    // MARK: - HealthKit

    // MARK: Workout Metrics

    public private(set) var averageHeartRate: Double = 0
    public private(set) var heartRate: Double = 0
    public private(set) var activeEnergy: Double = 0
    public private(set) var distance: Double = 0

    public var workoutStartDate: Date? {
        builder?.startDate
    }

    public var elapsedTime: Double? {
        builder?.elapsedTime
    }

    public private(set) var completedWorkoutData: WorkoutData?

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

    /// Request authorization to access HealthKit.
    public func requestAuthorization() {
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

        HealthStoreClient.store.requestAuthorization(
            toShare: typesToShare,
            read: typesToRead
        ) { success, error in
            // handle error
        }
    }

    private func startWorkout(of workoutType: WorkoutType) async {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType.asHKWorkoutActivityType
        configuration.locationType = .outdoor

        do {
            session = try HKWorkoutSession(
                healthStore: HealthStoreClient.store,
                configuration: configuration
            )

            builder = session?.associatedWorkoutBuilder()
        } catch {
            // we would handle errors here.
            return
        }

        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: HealthStoreClient.store,
            workoutConfiguration: configuration
        )

        session?.delegate = self
        builder?.delegate = self

        let startDate = Date()
        session?.startActivity(with: startDate)

        guard let builder else { return }
        do {
            try await builder.beginCollection(at: startDate)
            // workout started
        } catch is CancellationError {
            // we can prob ignore this
        } catch {
            // handle errors
        }
    }

    private func workoutData(from workout: HKWorkout) -> WorkoutData {
        let distanceStatistics: HKStatistics? = switch workout.workoutActivityType {
        case .running, .walking:
            workout.statistics(for: HKQuantityType(.distanceWalkingRunning))

        case .cycling:
            workout.statistics(for: HKQuantityType(.distanceCycling))

        default:
            // Workout type not supported by this app.
            nil
        }

        let distance = distanceStatistics?.sumQuantity()?.doubleValue(for: .meter()) ?? 0.0

        let activeEnergyBurned = workout.statistics(for: HKQuantityType(.activeEnergyBurned))?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0.0

        return WorkoutData(
            totalTime: workout.duration,
            totalDistance: distance,
            activeEnergyBurned: activeEnergyBurned
        )
    }
}

// MARK: - HKWorkoutSessionDelegate

extension RealWorkoutManager: HKWorkoutSessionDelegate {
    public nonisolated func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date
    ) {
        Task { @MainActor in
            switch toState {
            case .running:
                isWorkoutRunning = true

            case .ended:
                isWorkoutRunning = false

                do {
                    guard let builder else { return }
                    try await builder.endCollection(at: date)
                    let workout = try await builder.finishWorkout()

                    if let workout {
                        completedWorkoutData = workoutData(from: workout)
                    }
                } catch {
                    // handle errors
                }

            case .notStarted, .paused, .prepared, .stopped:
                isWorkoutRunning = false
            @unknown default:
                isWorkoutRunning = false
            }
        }
    }

    public nonisolated func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: any Error) {
        // present failure UI
    }
}

// MARK: - HKLiveWorkoutBuilderDelegate

extension RealWorkoutManager: HKLiveWorkoutBuilderDelegate {
    public nonisolated func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // unimplemented
    }

    public nonisolated func workoutBuilder(
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
