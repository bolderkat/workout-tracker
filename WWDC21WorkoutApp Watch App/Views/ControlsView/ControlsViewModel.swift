//
//  ControlsViewModel.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation
import WorkoutManager

@MainActor
@Observable final class ControlsViewModel {
    private let workoutManager: WorkoutManaging

    init(workoutManager: WorkoutManaging) {
        self.workoutManager = workoutManager
    }

    var playPauseButtonIconName: String {
        workoutManager.isWorkoutRunning ? "pause" : "play"
    }

    var playPauseButtonTitle: String {
        workoutManager.isWorkoutRunning ? "Pause" : "Resume"
    }

    func endWorkout() {
        workoutManager.endWorkout()
    }

    func togglePause() {
        workoutManager.togglePause()
    }
}
