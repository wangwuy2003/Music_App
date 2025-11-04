//
//  RecentSearchManager.swift
//  Rhythm
//
//  Created by MacMini A6 on 4/11/25.
//

import Foundation

class RecentSearchManager {
    private let key = "recent_searches"
    private let maxItems = 30
    
    static let shared = RecentSearchManager()
    
    private init() {}
    
    func load() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
    
    func save(_ items: [String]) {
        UserDefaults.standard.set(items, forKey: key)
    }
    
    func add(_ item: String) {
        guard !item.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        var current = load()
        
        current.removeAll { $0.caseInsensitiveCompare(item) == .orderedSame }
        current.insert(item, at: 0)
        
        if current.count > maxItems {
            current = Array(current.prefix(maxItems))
        }
        
        save(current)
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
