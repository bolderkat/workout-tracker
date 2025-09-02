//
//  RootViewModel.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation
import WorkoutManager

@MainActor
@Observable final class RootViewModel {
    private var workoutManager: WorkoutManaging

    init(workoutManager: WorkoutManaging) {
        self.workoutManager = workoutManager
    }

    var isShowingSummaryView: Bool {
        get {
            workoutManager.isShowingSummaryView
        }
        set {
            workoutManager.isShowingSummaryView = newValue
        }
    }
}
