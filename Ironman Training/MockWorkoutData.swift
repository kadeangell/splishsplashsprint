//
//  MockWorkoutData.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import Foundation

struct MockWorkoutData {
    static func generateWorkouts(startDate: Date = Date(), numberOfDays: Int = 30) -> [Workout] {
        var workouts: [Workout] = []
        let calendar = Calendar.current
        let oneHour: TimeInterval = 3600 // 1 hour in seconds

        // Workout types cycling through: Swim, Bike, Run, Strength, Rest
        let workoutTypes: [WorkoutType] = [.swim, .bike, .run, .strength, .rest]

        for day in 0..<numberOfDays {
            guard let workoutDate = calendar.date(byAdding: .day, value: -day, to: startDate) else {
                continue
            }

            // Rotate through workout types
            let workoutType = workoutTypes[day % workoutTypes.count]

            let workout: Workout
            switch workoutType {
            case .swim:
                workout = Workout(
                    date: workoutDate,
                    type: .swim,
                    plannedDistance: 2000, // meters
                    plannedDuration: oneHour,
                    plannedDescription: "Easy swim - focus on technique"
                )
            case .bike:
                workout = Workout(
                    date: workoutDate,
                    type: .bike,
                    plannedDistance: 20, // miles
                    plannedDuration: oneHour,
                    plannedDescription: "Moderate pace ride"
                )
            case .run:
                workout = Workout(
                    date: workoutDate,
                    type: .run,
                    plannedDistance: 6, // miles
                    plannedDuration: oneHour,
                    plannedDescription: "Steady run - maintain zone 2 heart rate"
                )
            case .strength:
                workout = Workout(
                    date: workoutDate,
                    type: .strength,
                    plannedDistance: nil,
                    plannedDuration: oneHour,
                    plannedDescription: "Full body strength training"
                )
            case .rest:
                workout = Workout(
                    date: workoutDate,
                    type: .rest,
                    plannedDistance: nil,
                    plannedDuration: 0,
                    plannedDescription: "Rest and recovery day"
                )
            }

            workouts.append(workout)
        }

        return workouts
    }

    // Get today's workout
    static func todaysWorkout() -> Workout? {
        let workouts = generateWorkouts(numberOfDays: 1)
        return workouts.first
    }

    // Get this week's workouts
    static func thisWeeksWorkouts() -> [Workout] {
        return generateWorkouts(numberOfDays: 7)
    }
}
