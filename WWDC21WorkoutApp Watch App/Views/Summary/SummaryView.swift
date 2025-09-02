//
//  SummaryView.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/28/25.
//

import HealthKit
import SwiftUI
import WorkoutManager

struct SummaryView: View {
    @Environment(\.dismiss) var dismiss

    @State private var viewModel: SummaryViewModel

    init(workoutManager: WorkoutManaging) {
        viewModel = SummaryViewModel(workoutManager: workoutManager)
    }

    var body: some View {
        if viewModel.savedWorkout == nil {
            ProgressView("Saving workout")
                .navigationBarHidden(true)
        } else {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    SummaryMetricView(
                        title: "Total Time",
                        value: viewModel.totalTime
                    )
                    .accentColor(.yellow)

                    SummaryMetricView(
                        title: "Total Distance",
                        value: viewModel.totalDistance
                    )
                    .accentColor(.green)

                    SummaryMetricView(
                        title: "Total Energy",
                        value: viewModel.totalEnergy
                    )
                    .accentColor(.pink)

                    SummaryMetricView(
                        title: "Avg. Heart Rate",
                        value: viewModel.averageHeartRate
                    )
                    .accentColor(.red)

                    Text("Activity Rings")

                    ActivityRingsView(healthStore: viewModel.healthStore)
                        .frame(width: 50, height: 50)

                    Button("Done") {
                        dismiss()
                    }
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct SummaryMetricView: View {
    var title: String
    var value: String

    var body: some View {
        Text(title)
        Text(value)
            .font(
                .system(.title2, design: .rounded)
                    .lowercaseSmallCaps()
            )
            .foregroundColor(.accentColor)
        Divider()
    }
}

#Preview {
    SummaryView(workoutManager: FakeWorkoutManager())
}
