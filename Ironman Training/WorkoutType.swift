//
//  WorkoutType.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import Foundation

enum WorkoutType: String, CaseIterable, Codable {
    case swim = "Swim"
    case bike = "Bike"
    case run = "Run"
    case strength = "Strength"
    case rest = "Rest"

    var icon: String {
        switch self {
        case .swim:
            return "figure.pool.swim"
        case .bike:
            return "bicycle"
        case .run:
            return "figure.run"
        case .strength:
            return "dumbbell.fill"
        case .rest:
            return "bed.double.fill"
        }
    }
}