//
//  TodayView.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import SwiftUI

struct TodayView: View {
    @State private var workout: Workout?
    @State private var showingCalendar = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let workout = workout {
                    ScrollView {
                        VStack(spacing: 30) {
                            // Workout Type Icon
                            Image(systemName: workout.type.icon)
                                .font(.system(size: 80))
                                .foregroundStyle(.blue)
                                .padding()

                            // Workout Type
                            Text(workout.type.rawValue)
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            // Workout Details Card
                            VStack(alignment: .leading, spacing: 16) {
                                if let distance = workout.plannedDistance {
                                    HStack {
                                        Image(systemName: "ruler")
                                            .foregroundStyle(.blue)
                                        Text("Distance:")
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Text(formatDistance(distance, type: workout.type))
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

                            // Complete Button
                            Button(action: {
                                // TODO: Mark workout as complete
                            }) {
                                HStack {
                                    Image(systemName: workout.completed ? "checkmark.circle.fill" : "circle")
                                    Text(workout.completed ? "Completed" : "Mark as Complete")
                                }
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(workout.completed ? Color.green : Color.blue)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            .disabled(workout.completed)
                        }
                        .padding(.vertical)
                    }
                } else {
                    ContentUnavailableView(
                        "No Workout Today",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text("Enjoy your rest day!")
                    )
                }
            }
            .navigationTitle("Today's Workout")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingCalendar = true
                    }) {
                        Image(systemName: "calendar")
                    }
                }
            }
            .sheet(isPresented: $showingCalendar) {
                CalendarView()
            }
            .onAppear {
                loadTodaysWorkout()
            }
        }
    }

    private func loadTodaysWorkout() {
        workout = MockWorkoutData.todaysWorkout()
    }

    private func formatDistance(_ distance: Double, type: WorkoutType) -> String {
        switch type {
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
    TodayView()
}