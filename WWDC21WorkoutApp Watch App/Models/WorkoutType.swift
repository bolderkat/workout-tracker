//
//  WorkoutType.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

enum WorkoutType: Int, Identifiable {
    case running
    case cycling
    case walking

    public var id: Int {
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
        }
    }
}
