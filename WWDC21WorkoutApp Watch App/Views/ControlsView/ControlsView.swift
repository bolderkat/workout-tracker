//
//  ControlsView.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/28/25.
//

import SwiftUI
import WorkoutManager

struct ControlsView: View {
    @State private var viewModel: ControlsViewModel

    init(workoutManager: WorkoutManaging) {
        viewModel = ControlsViewModel(workoutManager: workoutManager)
    }

    var body: some View {
        HStack {
            VStack {
                Button {
                    viewModel.endWorkout()
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(.red)
                .font(.title2)
                Text("End")
            }

            VStack {
                Button {
                    viewModel.togglePause()
                } label: {
                    Image(systemName: viewModel.playPauseButtonIconName)
                }
                .tint(.yellow)
                .font(.title2)
                Text(viewModel.playPauseButtonTitle)
            }
        }
    }
}

#Preview {
    ControlsView(workoutManager: FakeWorkoutManager())
}
