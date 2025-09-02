//
//  StartView.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/27/25.
//

import SwiftUI
import WorkoutManager

struct StartView: View {
    private let workoutManager: WorkoutManaging
    @State private var viewModel: StartViewModel

    init(workoutManager: WorkoutManaging) {
        self.workoutManager = workoutManager
        viewModel = StartViewModel(workoutManager: workoutManager)
    }

    var body: some View {
        NavigationStack {
            List(viewModel.workoutTypes) { workoutType in
                Button(workoutType.name) {
                    viewModel.selectedWorkout = workoutType
                }
            }
            .listStyle(.carousel)
            .navigationBarTitle("Workouts")
            .navigationDestination(item: $viewModel.selectedWorkout) { workoutType in
                SessionPagingView(workoutManager: workoutManager)
            }
            .onAppear {
                viewModel.requestAuthorization()
            }
        }
    }
}

#Preview {
    StartView(workoutManager: FakeWorkoutManager())
}
