//
//  RootViewModel.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation

@Observable final class RootViewModel {
    private var workoutManager: WorkoutManager

    init(workoutManager: WorkoutManager) {
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
