//
//  String+Exts.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//
import Foundation.NSString
import SwiftUI

extension String {
    // from: https://github.com/NSAntoine/Antoine/blob/main/Antoine/Backend/Extensions/Foundation.swift#L43-L55
    // was given permission to use any code from antoine as I like - thank you Serena!~
    
    static public func localized(_ name: String) -> String {
        NSLocalizedString(name, comment: "")
    }
    
    static public func localized(_ name: String, arguments: CVarArg...) -> String {
        String(format: NSLocalizedString(name, comment: ""), arguments: arguments)
    }
    /// Localizes the current string using the main bundle.
    ///
    /// - Returns: The localized string.
    public func localized() -> String {
        String.localized(self)
    }
}

extension LocalizedStringKey {
    static public func localized(_ key: String) -> LocalizedStringKey {
        LocalizedStringKey(key)
    }
}
