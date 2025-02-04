//
//  Extensions.swift
//  WeatherAPI
//
//  Created by Wylan L Neely on 1/28/25.
//

import SwiftUI

extension Double {
    func asDisplayString() -> String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : "\(self)"
    }
    
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
                             .replacingOccurrences(of: "#", with: "")
        var hexNumber: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&hexNumber)
        
        let red = Double((hexNumber >> 16) & 0xFF) / 255.0
        let green = Double((hexNumber >> 8) & 0xFF) / 255.0
        let blue = Double(hexNumber & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
