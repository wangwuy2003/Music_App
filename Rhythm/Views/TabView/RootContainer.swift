//
//  RootContainer.swift
//  Rhythm
//
//  Created by Apple on 5/10/25.
//
import SwiftUI
import SwiftfulRouting

struct RootContainer: View {
    let router: AnyRouter

    @StateObject private var homeVM: HomeViewModel

    init(router: AnyRouter) {
        self.router = router
        _homeVM = StateObject(wrappedValue: HomeViewModel(router: router))
    }

    var body: some View {
        HomeView()
            .environmentObject(homeVM)
    }
}

struct LibraryContainer: View {
    let router: AnyRouter
    
    @StateObject private var libraryVM: LibraryViewModel

    init(router: AnyRouter) {
        self.router = router
        _libraryVM = StateObject(wrappedValue: LibraryViewModel(router: router))
    }
    
    var body: some View {
        RouterView(addNavigationStack: true, addModuleSupport: false) { innerRouter in
                    LibraryView()
                        .environmentObject(libraryVM)
                        .environment(\.router, innerRouter) // Gắn router con
                }
    }
}
