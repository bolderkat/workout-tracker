//
//  WWDC21WorkoutAppApp.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/27/25.
//

import SwiftUI
import WorkoutManager

@main
struct WWDC21WorkoutApp_Watch_AppApp: App {
    private var workoutManager: WorkoutManaging
    @State private var viewModel: RootViewModel

    init() {
        workoutManager = RealWorkoutManager()
        viewModel = RootViewModel(workoutManager: workoutManager)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                StartView(workoutManager: workoutManager)
            }
            .sheet(isPresented: $viewModel.isShowingSummaryView) {
                SummaryView(workoutManager: workoutManager)
            }
        }
    }
}
