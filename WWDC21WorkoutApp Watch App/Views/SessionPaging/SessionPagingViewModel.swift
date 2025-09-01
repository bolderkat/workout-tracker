//
//  SessionPagingViewModel.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

import Foundation

@Observable class SessionPagingViewModel {
    enum Tab {
        case controls
        case metrics
        case nowPlaying
    }

    private let workoutManager: WorkoutManager
    var selection: Tab = .metrics

    init(workoutManager: WorkoutManager) {
        self.workoutManager = workoutManager
    }

    var navigationTitle: String {
        workoutManager.selectedWorkout?.name ?? ""
    }

    var isNavigationBarHidden: Bool {
        selection == .nowPlaying
    }

    var isWorkoutRunning: Bool {
        workoutManager.isRunning
    }

    func displayMetricsView() {
        selection = .metrics
    }

}
