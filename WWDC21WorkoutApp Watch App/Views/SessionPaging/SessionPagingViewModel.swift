//
//  SessionPagingViewModel.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation
import WorkoutManager

@MainActor
@Observable class SessionPagingViewModel {
    enum Tab: CaseIterable {
        case controls
        case metrics
        case nowPlaying
    }

    private let workoutManager: WorkoutManaging
    var selection: Tab = .metrics

    init(workoutManager: WorkoutManaging) {
        self.workoutManager = workoutManager
    }

    var navigationTitle: String {
        workoutManager.selectedWorkout?.name ?? ""
    }

    var isNavigationBarHidden: Bool {
        selection == .nowPlaying
    }

    var isWorkoutRunning: Bool {
        workoutManager.isWorkoutRunning
    }

    func displayMetricsView() {
        selection = .metrics
    }

}
