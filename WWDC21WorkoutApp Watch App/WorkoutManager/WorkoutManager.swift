//
//  WorkoutManager.swift
//  WWDC21WorkoutApp Watch App
//
//  Created by Daniel Luo on 8/29/25.
//

import Foundation
import HealthKit

protocol WorkoutManager {
    var selectedWorkout: HKWorkoutActivityType? { get set }
    var isShowingSummaryView: Bool { get set }
    var isRunning: Bool { get }
    var builder: HKLiveWorkoutBuilder? { get }
    var averageHeartRate: Double { get }
    var heartRate: Double { get }
    var activeEnergy: Double { get }
    var distance: Double { get }
    var workout: HKWorkout? { get }
    var healthStore: HKHealthStore { get }

    func endWorkout()
    func togglePause()
    func requestAuthorization()
}
