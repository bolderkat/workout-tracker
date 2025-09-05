//
//  SessionPagingViewModelTests.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/4/25.
//

import Testing
import WorkoutManager
@testable import WWDC21WorkoutApp_Watch_App

struct SessionPagingViewModelTests {
    typealias Tab = SessionPagingViewModel.Tab
    @MainActor private let workoutManager = FakeWorkoutManager()

    // All of these tests are very simple and basically copy the VM logic,
    // but the value lies in being able to catch regressions.

    private static let selectedWorkouts = WorkoutType.allCases + [nil]

    @Test("Navigation title name", arguments: selectedWorkouts)
    func navigationTitleName(for selectedWorkout: WorkoutType?) async {
        let vm = await SessionPagingViewModel(workoutManager: workoutManager)

        await MainActor.run {
            workoutManager.selectedWorkout = selectedWorkout
        }

        if let selectedWorkout {
            #expect(await vm.navigationTitle == selectedWorkout.name)
        } else {
            #expect(await vm.navigationTitle == "")
        }
    }

    @Test("Navigation bar hidden", arguments: Tab.allCases)
    func navigationBarHidden(for selection: Tab) async {
        let vm = await SessionPagingViewModel(workoutManager: workoutManager)

        await MainActor.run {
            vm.selection = selection
        }

        let isSelectionNowPlaying = selection == .nowPlaying
        #expect(await vm.isNavigationBarHidden == isSelectionNowPlaying)
    }

    @Test("Workout running status", arguments: [true, false])
    func isWorkoutRunning(isRunning: Bool) async {
        let vm = await SessionPagingViewModel(workoutManager: workoutManager)

        await MainActor.run {
            workoutManager.isRunning = isRunning
        }

        #expect(await vm.isWorkoutRunning == isRunning)
    }

    @Test("Display metrics view", arguments: Tab.allCases)
    func displayMetricsView(from selection: Tab) async {
        let vm = await SessionPagingViewModel(workoutManager: workoutManager)

        await MainActor.run {
            vm.selection = selection
        }

        await vm.displayMetricsView()

        #expect(await vm.selection == .metrics)
    }
}
