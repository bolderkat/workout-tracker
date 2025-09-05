//
//  RootViewModelTests.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/5/25.
//

import Testing
import WorkoutManager
@testable import WWDC21WorkoutApp_Watch_App

struct RootViewModelTests {
    @MainActor private let workoutManager = FakeWorkoutManager()

    @Test("Summary view getter")
    func summaryViewGetter() async {
        let vm = await RootViewModel(workoutManager: workoutManager)

        #expect(await !vm.isShowingSummaryView)

        await MainActor.run {
            workoutManager.didUserEndCurrentWorkout = true
        }

        #expect(await vm.isShowingSummaryView)
    }

    @Test("Summary view setter")
    func summaryViewSetter() async {
        await MainActor.run {
            let vm = RootViewModel(workoutManager: workoutManager)
            var resetWorkoutDataCount = 0
            workoutManager.onResetWorkoutData = {
                resetWorkoutDataCount += 1
            }

            vm.isShowingSummaryView = true

            #expect(resetWorkoutDataCount == 0)

            vm.isShowingSummaryView = false

            #expect(resetWorkoutDataCount == 1)

            vm.isShowingSummaryView = false // 2
            vm.isShowingSummaryView = false // 3
            vm.isShowingSummaryView = true
            vm.isShowingSummaryView = false // 4
            vm.isShowingSummaryView = true
            vm.isShowingSummaryView = true
            vm.isShowingSummaryView = false // 5

            #expect(resetWorkoutDataCount == 5)
        }
    }
}
