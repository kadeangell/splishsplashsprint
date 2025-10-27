//
//  WorkoutType.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import Foundation
import SwiftUI

enum WorkoutType: String, CaseIterable, Codable {
    case swim = "Swim"
    case bike = "Bike"
    case run = "Run"
    case strength = "Strength"
    case rest = "Rest"

    var icon: Image {
        switch self {
        case .swim:
            return Image("swim")
        case .bike:
            return Image("bike")
        case .run:
            return Image("run")
        case .strength:
            return Image("lift")
        case .rest:
            return Image("bed")
        }
    }
}
