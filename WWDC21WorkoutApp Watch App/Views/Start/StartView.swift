//
//  StartView.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/27/25.
//

import HealthKit
import SwiftUI

struct StartView: View {
    private let workoutManager: WorkoutManager
    @State private var viewModel: StartViewModel

    init(workoutManager: WorkoutManager) {
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

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .running:
            return "Run"
        case .cycling:
            return "Bike"
        case .walking:
            return "Walk"
        default:
            return ""
        }
    }
}
