//
//  ActivityRingsView.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/29/25.
//

import Foundation
import HealthKit
@preconcurrency import SwiftUI

// This is safe to do within the context of this file
// because we're only reading the summary when passing it to the UI
// and not mutating it in any way.
extension HKActivitySummary: @unchecked @retroactive Sendable {}

public struct ActivityRingsView: WKInterfaceObjectRepresentable {
    public init() {}

    public func makeWKInterfaceObject(context: Context) -> some WKInterfaceObject {
        let activityRingsObject = WKInterfaceActivityRing()

        let calendar = Calendar.current
        var components = calendar.dateComponents([.era, .year, .month, .day], from: Date())
        components.calendar = calendar

        let predicate = HKQuery.predicateForActivitySummary(with: components)

        let query = HKActivitySummaryQuery(predicate: predicate) { _, summaries, _ in
            Task { @MainActor in
                activityRingsObject.setActivitySummary(summaries?.first, animated: true)
            }
        }

        HealthStoreClient.store.execute(query)

        return activityRingsObject
    }

    public func updateWKInterfaceObject(
        _ wkInterfaceObject: WKInterfaceObjectType,
        context: Context
    ) {}
}
