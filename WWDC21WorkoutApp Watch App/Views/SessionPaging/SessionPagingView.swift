//
//  SessionPagingView.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/27/25.
//

import SwiftUI
import WatchKit
import WorkoutManager

struct SessionPagingView: View {
    private typealias Tab = SessionPagingViewModel.Tab

    @Environment(\.isLuminanceReduced) private var isLuminanceReduced
    private let workoutManager: WorkoutManaging
    @State private var viewModel: SessionPagingViewModel

    init(workoutManager: WorkoutManaging) {
        self.workoutManager = workoutManager
        viewModel = SessionPagingViewModel(workoutManager: workoutManager)
    }

    var body: some View {
        TabView(selection: $viewModel.selection) {
            ControlsView(workoutManager: workoutManager)
                .tag(Tab.controls)
            MetricsView(workoutManager: workoutManager)
                .tag(Tab.metrics)
            NowPlayingView()
                .tag(Tab.nowPlaying)
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarBackButtonHidden()
        .navigationBarHidden(viewModel.isNavigationBarHidden)
        .onChange(of: viewModel.isWorkoutRunning) {
            displayMetricsView()
        }
        .tabViewStyle(
            PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic)
        )
        .onChange(of: isLuminanceReduced) {
            displayMetricsView()
        }
    }

    private func displayMetricsView() {
        withAnimation {
            viewModel.displayMetricsView()
        }
    }
}

#Preview {
    SessionPagingView(workoutManager: FakeWorkoutManager())
}
