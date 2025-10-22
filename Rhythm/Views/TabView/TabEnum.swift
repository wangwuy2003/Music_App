//
//  TabEnum.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

enum TabEnum: String, CaseIterable, Hashable {
    case home
    case search
    case library
    case profile
    
    var title: String {
        switch self {
        case .home:         return .localized("Home")
        case .search:       return .localized("Search")
        case .library:      return .localized("Library")
        case .profile:      return .localized("Profile")
        }
    }
    
    var image: String {
        switch self {
        case .home:         return "house.fill"
        case .search:       return "magnifyingglass"
        case .library:      return "music.note"
        case .profile:      return "person.fill"
        }
    }
    
    @ViewBuilder
    func view(router: AnyRouter) -> some View {
        switch self {
        case .home:             RootContainer(router: router)
        case .search:           SearchView()
        case .library:          LibraryView()
        case .profile:          ProfileView()
        }
    }
    
    static var defaultTabs: [TabEnum] {
        return [
            .home,
            .search,
            .library,
            .profile,
        ]
    }
}
