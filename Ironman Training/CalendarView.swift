//
//  CalendarView.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var workouts: [Workout] = []
    @State private var selectedWorkout: Workout?
    @State private var showingWorkoutDetail = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(groupWorkoutsByWeek(), id: \.0) { weekStart, weekWorkouts in
                        VStack(alignment: .leading, spacing: 12) {
                            // Week header
                            Text(formatWeekRange(weekStart: weekStart))
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)

                            // Workout cards for the week
                            ForEach(weekWorkouts) { workout in
                                WorkoutCard(workout: workout)
                                    .onTapGesture {
                                        selectedWorkout = workout
                                        showingWorkoutDetail = true
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Training Calendar")
            .onAppear {
                loadWorkouts()
            }
            .sheet(isPresented: $showingWorkoutDetail) {
                if let workout = selectedWorkout {
                    WorkoutDetailView(workout: workout)
                }
            }
        }
    }

    private func loadWorkouts() {
        workouts = MockWorkoutData.generateWorkouts(numberOfDays: 30)
    }

    private func groupWorkoutsByWeek() -> [(Date, [Workout])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: workouts) { workout in
            calendar.dateInterval(of: .weekOfYear, for: workout.date)?.start ?? workout.date
        }

        return grouped.sorted { $0.key > $1.key }.map { ($0.key, $0.value.sorted { $0.date > $1.date }) }
    }

    private func formatWeekRange(weekStart: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        guard let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart) else {
            return formatter.string(from: weekStart)
        }

        let startString = formatter.string(from: weekStart)
        let endString = formatter.string(from: weekEnd)

        return "Week of \(startString) - \(endString)"
    }
}

struct WorkoutCard: View {
    let workout: Workout

    var body: some View {
        HStack(spacing: 16) {
            // Date
            VStack {
                Text(workout.date, format: .dateTime.day())
                    .font(.title2)
                    .fontWeight(.bold)
                Text(workout.date, format: .dateTime.weekday(.abbreviated))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 50)

            // Workout icon
            Image(systemName: workout.type.icon)
                .font(.title2)
                .foregroundStyle(workout.completed ? .green : .blue)
                .frame(width: 40)

            // Workout details
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.type.rawValue)
                    .font(.headline)

                if let distance = workout.plannedDistance {
                    Text(formatDistance(distance, type: workout.type))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(formatDuration(workout.plannedDuration))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Completion indicator
            if workout.completed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.title3)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }

    private func formatDistance(_ distance: Double, type: WorkoutType) -> String {
        switch type {
        case .swim:
            return "\(Int(distance))m"
        case .bike, .run:
            return String(format: "%.1f mi", distance)
        default:
            return ""
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "Rest"
        }
    }
}

struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: workout.type.icon)
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                    .padding()

                Text(workout.type.rawValue)
                    .font(.title)
                    .fontWeight(.bold)

                Text(workout.date, format: .dateTime.month().day().year())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 16) {
                    if let distance = workout.plannedDistance {
                        HStack {
                            Image(systemName: "ruler")
                                .foregroundStyle(.blue)
                            Text("Distance:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(formatDistance(distance))
                                .foregroundStyle(.secondary)
                        }
                    }

                    if workout.plannedDuration > 0 {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundStyle(.blue)
                            Text("Duration:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(formatDuration(workout.plannedDuration))
                                .foregroundStyle(.secondary)
                        }
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundStyle(.blue)
                            Text("Description:")
                                .fontWeight(.semibold)
                        }
                        Text(workout.plannedDescription)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)

                // Trade with Today button
                if !isToday {
                    Button(action: {
                        // TODO: Implement workout swap logic
                    }) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                            Text("Trade with Today")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Workout Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var isToday: Bool {
        Calendar.current.isDateInToday(workout.date)
    }

    private func formatDistance(_ distance: Double) -> String {
        switch workout.type {
        case .swim:
            return "\(Int(distance)) meters"
        case .bike, .run:
            return String(format: "%.1f miles", distance)
        default:
            return ""
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    CalendarView()
}