//
//  ContentView.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }

            StopwatchView()
                .tabItem {
                    Label("Stopwatch", systemImage: "stopwatch")
                }

            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
        }
    }
}

#Preview {
    ContentView()
}
