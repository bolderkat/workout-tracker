//
//  SessionPagingView.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/27/25.
//

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    private typealias ViewModel = SessionPagingViewModel

    @Environment(\.isLuminanceReduced) private var isLuminanceReduced
    private let workoutManager: WorkoutManager
    @State private var viewModel: ViewModel

    init(workoutManager: WorkoutManager) {
        self.workoutManager = workoutManager
        viewModel = SessionPagingViewModel(workoutManager: workoutManager)
    }

    var body: some View {
        TabView(selection: $viewModel.selection) {
            ControlsView(workoutManager: workoutManager)
                .tag(ViewModel.Tab.controls)
            MetricsView(workoutManager: workoutManager)
                .tag(ViewModel.Tab.metrics)
            NowPlayingView()
                .tag(ViewModel.Tab.nowPlaying)
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
