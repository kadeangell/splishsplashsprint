//
//  Workout.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import Foundation

struct Workout: Identifiable, Codable {
    let id: UUID
    let date: Date
    let type: WorkoutType
    let plannedDistance: Double? // in miles or meters
    let plannedDuration: TimeInterval // in seconds
    let plannedDescription: String
    var actualDistance: Double?
    var actualDuration: TimeInterval?
    var actualPace: Double?
    var completed: Bool
    var notes: String?

    init(
        id: UUID = UUID(),
        date: Date,
        type: WorkoutType,
        plannedDistance: Double? = nil,
        plannedDuration: TimeInterval,
        plannedDescription: String,
        actualDistance: Double? = nil,
        actualDuration: TimeInterval? = nil,
        actualPace: Double? = nil,
        completed: Bool = false,
        notes: String? = nil
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.plannedDistance = plannedDistance
        self.plannedDuration = plannedDuration
        self.plannedDescription = plannedDescription
        self.actualDistance = actualDistance
        self.actualDuration = actualDuration
        self.actualPace = actualPace
        self.completed = completed
        self.notes = notes
    }
}