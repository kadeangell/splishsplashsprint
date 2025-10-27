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
                                .fontWeight(.semibold)
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
            .navigationBarTitleDisplayMode(.inline)
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
                    .font(.custom("PixelifySans-Bold", size: 22))
                Text(workout.date, format: .dateTime.weekday(.abbreviated))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 50)

            // Workout icon
            workout.type.icon
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)

            // Workout details
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.type.rawValue)
                    .fontWeight(.semibold)

                if let distance = workout.plannedDistance {
                    Text(formatDistance(distance, type: workout.type))
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
                    .foregroundStyle(Color.theme.accent)
                    .frame(width: 24, height: 24)
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
                workout.type.icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding()

                Text(workout.type.rawValue)
                    .font(.custom("PixelifySans-Bold", size: 28))
                    .foregroundStyle(Color.theme.text)

                Text(workout.date, format: .dateTime.month().day().year())
                    .foregroundStyle(Color.theme.secondary)

                VStack(alignment: .leading, spacing: 16) {
                    if let distance = workout.plannedDistance {
                        HStack {
                            Image("ruler")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text("Distance:")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.theme.text)
                            Spacer()
                            Text(formatDistance(distance))
                                .foregroundStyle(Color.theme.secondary)
                        }
                    }

                    if workout.plannedDuration > 0 {
                        HStack {
                            Image("clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text("Duration:")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.theme.text)
                            Spacer()
                            Text(formatDuration(workout.plannedDuration))
                                .foregroundStyle(Color.theme.secondary)
                        }
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image("description")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text("Description:")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.theme.text)
                        }
                        Text(workout.plannedDescription)
                            .foregroundStyle(Color.theme.secondary)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.secondary.opacity(0.1))
                )
                .padding(.horizontal)

                // Trade with Today button
                if !isToday {
                    Button(action: {
                        // TODO: Implement workout swap logic
                    }) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                                .foregroundStyle(Color.theme.text)
                                .frame(width: 20, height: 20)
                            Text("Trade with Today")
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.theme.text)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.theme.accent)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .background(Color.theme.background)
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