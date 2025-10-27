//
//  StopwatchView.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import SwiftUI

struct StopwatchView: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var isRunning = false
    @State private var timer: Timer?
    @State private var startTime: Date?

    var body: some View {
        VStack(spacing: 30) {
            Text(timeString(from: elapsedTime))
                .font(.custom("PixelifySans-Regular", size: 60))
                .foregroundStyle(Color.theme.text)

            HStack(spacing: 20) {
                Button(isRunning ? "Stop" : "Start") {
                    if isRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }
                .fontWeight(.semibold)
                .buttonStyle(.borderedProminent)
                .tint(Color.theme.primary)

                Button("Reset") {
                    resetTimer()
                }
                .fontWeight(.semibold)
                .buttonStyle(.bordered)
                .tint(Color.theme.secondary)
                .disabled(elapsedTime == 0 && !isRunning)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.theme.background)
    }

    func startTimer() {
        let currentElapsed = elapsedTime
        startTime = Date().addingTimeInterval(-currentElapsed)
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if let startTime = startTime {
                elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }

    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        startTime = nil
    }

    func resetTimer() {
        stopTimer()
        elapsedTime = 0
        startTime = nil
    }

    func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

#Preview {
    StopwatchView()
}
