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
                            workout.type.icon
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .foregroundStyle(Color.theme.primary)
                                .frame(width: 80, height: 80)
                                .padding()

                            // Workout Type
                            Text(workout.type.rawValue)
                                .font(.custom("PixelifySans-Regular", size: 34))
                                .foregroundStyle(Color.theme.text)

                            // Workout Details Card
                            VStack(alignment: .leading, spacing: 16) {
                                if let distance = workout.plannedDistance {
                                    HStack {
                                        Image("ruler")
                                            .resizable()
                                            .renderingMode(.template)
                                            .scaledToFit()
                                            .foregroundStyle(Color.theme.primary)
                                            .frame(width: 20, height: 20)
                                        Text("Distance:")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.theme.text)
                                        Spacer()
                                        Text(formatDistance(distance, type: workout.type))
                                            .foregroundStyle(Color.theme.secondary)
                                    }
                                }

                                if workout.plannedDuration > 0 {
                                    HStack {
                                        Image("clock")
                                            .resizable()
                                            .renderingMode(.template)
                                            .scaledToFit()
                                            .foregroundStyle(Color.theme.primary)
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
                                            .renderingMode(.template)
                                            .scaledToFit()
                                            .foregroundStyle(Color.theme.primary)
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

                            // Complete Button
                            Button(action: {
                                // TODO: Mark workout as complete
                            }) {
                                HStack {
                                    Image(workout.completed ? "circle-filled" : "circle")
                                        .resizable()
                                        .renderingMode(.template)
                                        .scaledToFit()
                                        .foregroundStyle(Color.theme.text)
                                        .frame(width: 24, height: 24)
                                    Text(workout.completed ? "Completed" : "Mark as Complete")
                                }
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.theme.text)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(workout.completed ? Color.theme.accent : Color.theme.primary)
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
            .background(Color.theme.background)
            .navigationTitle("Today's Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingCalendar = true
                    }) {
                        Image("calendar")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundStyle(Color.theme.text)
                            .frame(width: 22, height: 22)
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
