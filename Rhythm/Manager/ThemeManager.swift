//
//  ThemeManager.swift
//  Rhythm
//
//  Created by MacMini A6 on 4/12/25.
//
import SwiftUI

final class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    static let shared = ThemeManager()
    
    var backgroundColor: Color {
        isDarkMode ? .black : Color(.systemGroupedBackground)
    }
    
    var secondaryColor: Color {
        isDarkMode ? Color.white.opacity(0.05) : .white
    }
    
    var textColor: Color {
        isDarkMode ? .white : .black
    }
}
