//
//  String+Exts.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import Foundation
import SwiftUI

extension String {
    
    static public func localized(_ name: String) -> String {
        // Sử dụng bundle từ LanguageManager thay vì mặc định
        return NSLocalizedString(name, tableName: nil, bundle: LanguageManager.shared.bundle ?? .main, value: "", comment: "")
    }
    
    static public func localized(_ name: String, arguments: CVarArg...) -> String {
        let format = NSLocalizedString(name, tableName: nil, bundle: LanguageManager.shared.bundle ?? .main, value: "", comment: "")
        return String(format: format, arguments: arguments)
    }
    
    public func localized() -> String {
        return String.localized(self)
    }
}

// Giúp LocalizedStringKey cũng nhận diện được thay đổi
extension LocalizedStringKey {
    static public func localized(_ key: String) -> LocalizedStringKey {
        return LocalizedStringKey(String.localized(key))
    }
}
