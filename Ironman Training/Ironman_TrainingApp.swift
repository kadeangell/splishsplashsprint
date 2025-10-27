//
//  Ironman_TrainingApp.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import SwiftUI

@main
struct Ironman_TrainingApp: App {
    init() {
        setupNavigationBarAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func setupNavigationBarAppearance() {
        // Configure navigation bar to use Pixelify Sans font
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        // Inline title (small title)
        if let customFont = UIFont(name: "PixelifySans-Regular", size: 17) {
            appearance.titleTextAttributes = [.font: customFont]
            print("✅ Navigation font loaded: PixelifySans-Regular")
        } else {
            print("❌ Failed to load PixelifySans-Regular")
        }

        // Large title
        if let customLargeFont = UIFont(name: "PixelifySans-Bold", size: 34) {
            appearance.largeTitleTextAttributes = [.font: customLargeFont]
        }

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        // Configure tab bar to use Pixelify Sans
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()

        if let tabFont = UIFont(name: "PixelifySans-Regular", size: 10) {
            let normalAttributes: [NSAttributedString.Key: Any] = [.font: tabFont]
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = normalAttributes
            tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
            tabBarAppearance.inlineLayoutAppearance.selected.titleTextAttributes = normalAttributes
            tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
            tabBarAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = normalAttributes
        }

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        // Set tab bar icon tint color
        UITabBar.appearance().tintColor = UIColor(Color.theme.primary)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.theme.text.opacity(0.5))
    }
}
