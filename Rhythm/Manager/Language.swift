//
//  Language.swift
//  Rhythm
//
//  Created by MacMini A6 on 4/12/25.
//


//
//  LanguageManager.swift
//  Rhythm
//
//  Created by MacMini A6 on 4/12/25.
//

import SwiftUI

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case vietnamese = "vi"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .vietnamese: return "Tiếng Việt"
        }
    }
    
    var icon: String {
        switch self {
        case .english: return "🇺🇸"
        case .vietnamese: return "🇻🇳"
        }
    }
}

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    
    // Lấy Bundle tương ứng với ngôn ngữ đã chọn
    var bundle: Bundle? {
        guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj") else {
            return Bundle.main
        }
        return Bundle(path: path)
    }
}