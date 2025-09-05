//
//  WWDC21WorkoutApp_Watch_AppTests.swift
//  WWDC21WorkoutApp Watch AppTests
//
//  Created by Daniel Luo on 8/27/25.
//

import Testing
import WorkoutManager
@testable import WWDC21WorkoutApp_Watch_App

struct SummaryViewModelTests {
    @MainActor private var workoutManager = FakeWorkoutManager()

    private static let workoutData: [WorkoutData?] = [
        nil,
        WorkoutData(
            totalTime: 2.0,
            totalDistance: 3.0,
            activeEnergyBurned: 4.0
        )
    ]

    /// Values to be fed into distance, calorie burn and HR methods.
    private static let metricValues = [
        102.3,
        19999.2,
        0.43,
        nil,
        0,
        -102,
    ]

    private static let expectedTimeStrings = [
        "00:01:42",
        "05:33:19",
        "00:00:00",
        "00:00:00",
        "00:00:00",
        "00:01:42",
    ]

    private static let expectedDistanceStrings = [
        "350 ft",
        "12 mi",
        "1 ft",
        "0 ft",
        "0 ft",
        "-350 ft",
    ]

    private static let expectedEnergyStrings = [
        "102 Cal",
        "19,999 Cal",
        "0 Cal",
        "0 Cal",
        "0 Cal",
        "-102 Cal",
    ]

    private static let expectedHeartRateStrings = [
        "102 bpm",
        "19,999 bpm",
        "0 bpm",
        "0 bpm",
        "-102 bpm",
    ]

    @Test(arguments: zip(workoutData, workoutData))
    func completedWorkoutData(workoutManagerData: WorkoutData?, viewModelData: WorkoutData?) async throws {
        #expect(workoutManagerData == viewModelData)
    }

    @Test("Total time metric", arguments: zip(metricValues, expectedTimeStrings))
    func totalTime(value: Double?, string: String) async {
        let vm = await SummaryViewModel(workoutManager: workoutManager)

        if let value {
            await MainActor.run {
                workoutManager.completedWorkoutData = WorkoutData(
                    totalTime: value,
                    totalDistance: 0,
                    activeEnergyBurned: 0
                )
            }
        }

        await #expect(vm.totalTime == string)
    }

    @Test("Total distance metric", arguments: zip(metricValues, expectedDistanceStrings))
    func totalDistance(value: Double?, string: String) async {
        let vm = await SummaryViewModel(workoutManager: workoutManager)

        if let value {
            await MainActor.run {
                workoutManager.completedWorkoutData = WorkoutData(
                    totalTime: 0,
                    totalDistance: value,
                    activeEnergyBurned: 0
                )
            }
        }

        await #expect(vm.totalDistance == string)
    }

    @Test("Total energy metric", arguments: zip(metricValues, expectedEnergyStrings))
    func totalEnergy(value: Double?, string: String) async {
        let vm = await SummaryViewModel(workoutManager: workoutManager)

        if let value {
            await MainActor.run {
                workoutManager.completedWorkoutData = WorkoutData(
                    totalTime: 0,
                    totalDistance: 0,
                    activeEnergyBurned: value
                )
            }
        }

        await #expect(vm.totalEnergy == string)
    }

    @Test("Average heart rate metric", arguments: zip(metricValues.compactMap { $0 }, expectedHeartRateStrings))
    func averageHeartRate(value: Double, string: String) async {
        let vm = await SummaryViewModel(workoutManager: workoutManager)

        await MainActor.run {
            workoutManager.averageHeartRate = value
        }

        await #expect(vm.averageHeartRate == string)
    }
}
