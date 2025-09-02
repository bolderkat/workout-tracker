//
//  MetricsView.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/27/25.
//

import SwiftUI
import WorkoutManager

struct MetricsView: View {
    @State private var viewModel: MetricsViewModel

    init(workoutManager: WorkoutManaging) {
        viewModel = MetricsViewModel(workoutManager: workoutManager)
    }

    var body: some View {
        TimelineView(
            MetricsTimelineSchedule(
                from: viewModel.timelineStartDate
            )
        ) { context in
            VStack(alignment: .leading) {
                ElapsedTimeView(
                    elapsedTime: viewModel.elapsedTime,
                    showSubseconds: context.cadence == .live
                )
                .foregroundStyle(.yellow)
                Text(viewModel.elapsedEnergy)
                Text(viewModel.heartRate)
                Text(viewModel.distance)
            }
            .font(.system(.title, design: .rounded)
                .monospacedDigit()
                .lowercaseSmallCaps()
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
        }
}

#Preview {
    MetricsView(workoutManager: FakeWorkoutManager())
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date

    init(from startDate: Date) {
        self.startDate = startDate
    }

    func entries(
        from startDate: Date,
        mode: Mode
    ) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(
            from: startDate,
            by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
        ).entries(
            from: startDate,
            mode: mode
        )
    }
}
