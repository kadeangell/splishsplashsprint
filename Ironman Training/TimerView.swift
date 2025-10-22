//
//  TimerView.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import SwiftUI

struct TimerView: View {
    @State private var timeRemaining: TimeInterval = 0
    @State private var totalTime: TimeInterval = 0
    @State private var isRunning = false
    @State private var timer: Timer?
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var selectedSeconds = 0

    var body: some View {
        VStack(spacing: 30) {
            if isRunning || timeRemaining > 0 {
                Text(timeString(from: timeRemaining))
                    .font(.system(size: 60, design: .monospaced))
            } else {
                HStack(spacing: 0) {
                    Picker("Hours", selection: $selectedHours) {
                        ForEach(0..<24) { hour in
                            Text("\(hour)").tag(hour)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 60)
                    Text("h").font(.title2)

                    Picker("Minutes", selection: $selectedMinutes) {
                        ForEach(0..<60) { minute in
                            Text("\(minute)").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 60)
                    Text("m").font(.title2)

                    Picker("Seconds", selection: $selectedSeconds) {
                        ForEach(0..<60) { second in
                            Text("\(second)").tag(second)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 60)
                    Text("s").font(.title2)
                }
                .frame(height: 150)
            }

            HStack(spacing: 20) {
                Button(isRunning ? "Pause" : "Start") {
                    if isRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedHours == 0 && selectedMinutes == 0 && selectedSeconds == 0 && timeRemaining == 0)

                Button("Reset") {
                    resetTimer()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }

    func setTimerFromPickers() {
        let totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
        timeRemaining = TimeInterval(totalSeconds)
        totalTime = timeRemaining
    }

    func startTimer() {
        if timeRemaining == 0 {
            setTimerFromPickers()
        }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 0.01
            } else {
                stopTimer()
            }
        }
    }

    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        stopTimer()
        timeRemaining = 0
        totalTime = 0
    }

    func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

#Preview {
    TimerView()
}
