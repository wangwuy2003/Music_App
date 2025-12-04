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
        case .english:          return .localized("English")
        case .vietnamese:       return .localized("Vietnamese")
        }
    }
    
    var icon: String {
        switch self {
        case .english:          return "🇺🇸"
        case .vietnamese:       return "🇻🇳"
        }
    }
}

import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    var selectedLanguage: String {
        get { UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en" }
        set { UserDefaults.standard.set(newValue, forKey: "selectedLanguage") }
    }
    
    var bundle: Bundle? {
        let language = selectedLanguage
        
        if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
            return Bundle(path: path)
        }
        
        if language == "en" {
            let possibleEnglishNames = ["en", "English", "en-US", "Base"]
            
            for name in possibleEnglishNames {
                if let path = Bundle.main.path(forResource: name, ofType: "lproj") {
                    return Bundle(path: path)
                }
            }
        }
        
        print("⚠️ Không tìm thấy bundle cho ngôn ngữ: \(language)")
        print("📁 Các ngôn ngữ có sẵn trong App: \(Bundle.main.localizations)")
        
        return Bundle.main
    }
}
