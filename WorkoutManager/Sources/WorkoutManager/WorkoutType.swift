//
//  WorkoutType.swift
//  WWDC21WorkoutApp
//
//  Created by Daniel Luo on 9/1/25.
//

public enum WorkoutType: Int, Identifiable {
    case running
    case cycling
    case walking

    public var id: Int {
        rawValue
    }

    public var name: String {
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
