//
//  Theme.swift
//  Ironman Training
//
//  Created by Kade Angell on 10/21/25.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    // Light mode colors
    let lightText = Color(hex: "040820")
    let lightBackground = Color(hex: "c7c8e6")
    let lightPrimary = Color(hex: "29ffd4")
    let lightSecondary = Color(hex: "2c096d")
    let lightAccent = Color(hex: "c29b00")

    // Dark mode colors
    let darkText = Color(hex: "dfe3fb")
    let darkBackground = Color(hex: "191a38")
    let darkPrimary = Color(hex: "00d6ab")
    let darkSecondary = Color(hex: "b592f6")
    let darkAccent = Color(hex: "ffd83d")

    // Adaptive colors that change based on color scheme
    var text: Color {
        Color(light: lightText, dark: darkText)
    }

    var background: Color {
        Color(light: lightBackground, dark: darkBackground)
    }

    var primary: Color {
        Color(light: lightPrimary, dark: darkPrimary)
    }

    var secondary: Color {
        Color(light: lightSecondary, dark: darkSecondary)
    }

    var accent: Color {
        Color(light: lightAccent, dark: darkAccent)
    }
}

// Helper extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    init(light: Color, dark: Color) {
        self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
}

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
}

// Custom Font Extension
extension Font {
    static func pixelifySans(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .medium:
            fontName = "PixelifySans-Medium"
        case .semibold:
            fontName = "PixelifySans-SemiBold"
        case .bold, .heavy, .black:
            fontName = "PixelifySans-Bold"
        default:
            fontName = "PixelifySans-Regular"
        }

        return .custom(fontName, size: size)
    }

    // Semantic font sizes using Pixelify Sans
    static var largeTitle: Font { .custom("PixelifySans-Bold", size: 34) }
    static var title: Font { .custom("PixelifySans-Bold", size: 28) }
    static var title2: Font { .custom("PixelifySans-Bold", size: 22) }
    static var title3: Font { .custom("PixelifySans-SemiBold", size: 20) }
    static var headline: Font { .custom("PixelifySans-SemiBold", size: 17) }
    static var body: Font { .custom("PixelifySans-Regular", size: 17) }
    static var callout: Font { .custom("PixelifySans-Regular", size: 16) }
    static var subheadline: Font { .custom("PixelifySans-Regular", size: 15) }
    static var footnote: Font { .custom("PixelifySans-Regular", size: 13) }
    static var caption: Font { .custom("PixelifySans-Regular", size: 12) }
    static var caption2: Font { .custom("PixelifySans-Regular", size: 11) }
}