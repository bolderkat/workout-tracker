//
//  ControlsViewModelTests.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/4/25.
//

import Testing
import WorkoutManager
@testable import WWDC21WorkoutApp_Watch_App

struct ControlsViewModelTests {
    @MainActor private let workoutManager = FakeWorkoutManager()

    private static let trueFalse = [true, false]

    private static let expectedIconNameAndTitle = [
        ("pause", "Pause"),
        ("play", "Resume")
    ]

    @Test("Play/pause button icon and title", arguments: zip(trueFalse, expectedIconNameAndTitle))
    func playPauseButtonIconAndTitle(isRunning: Bool, expected: (String, String)) async {
        let (expectedIconName, expectedTitle) = expected
        let vm = await ControlsViewModel(workoutManager: workoutManager)

        await MainActor.run {
            workoutManager.isWorkoutRunning = isRunning
        }

        #expect(await vm.playPauseButtonIconName == expectedIconName)
        #expect(await vm.playPauseButtonTitle == expectedTitle)
    }

    @MainActor
    @Test("End workout")
    func endWorkout() async {
        let vm = ControlsViewModel(workoutManager: workoutManager)
        var endWorkoutCount = 0

        workoutManager.onEndWorkout = {
            endWorkoutCount += 1
        }

        vm.endWorkout()
        vm.endWorkout()
        vm.endWorkout()

        #expect(endWorkoutCount == 3)
    }

    @MainActor
    @Test("Toggle pause")
    func togglePause() async {
        let vm = ControlsViewModel(workoutManager: workoutManager)
        var togglePauseCount = 0

        workoutManager.onTogglePause = {
            togglePauseCount += 1
        }

        vm.togglePause()
        vm.togglePause()
        vm.togglePause()

        #expect(togglePauseCount == 3)
    }
}
