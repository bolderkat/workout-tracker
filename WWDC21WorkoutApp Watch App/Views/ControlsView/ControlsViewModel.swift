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
        workoutManager.isRunning ? "pause" : "play"
    }

    var playPauseButtonTitle: String {
        workoutManager.isRunning ? "Pause" : "Resume"
    }

    func endWorkout() {
        workoutManager.endWorkout()
    }

    func togglePause() {
        workoutManager.togglePause()
    }
}
