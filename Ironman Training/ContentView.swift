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
                    Image("calendar")
                    Text("Today")
                }

            StopwatchView()
                .tabItem {
                    Image("stopwatch")
                    Text("Stopwatch")
                }

            TimerView()
                .tabItem {
                    Image("clock")
                    Text("Timer")
                }
        }
        .environment(\.font, .pixelifySans(size: 17))
    }
}

#Preview {
    ContentView()
}
