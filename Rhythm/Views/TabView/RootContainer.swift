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
        @EnvironmentObject var homeVM: HomeViewModel 

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
        LibraryView()
            .environmentObject(libraryVM)
    }
}

struct SettingsContainer: View {
    @State private var showSignInView: Bool = false
    
    var body: some View {
//        ZStack {
//            if !showSignInView {
//                SettingsView(showSignInView: $showSignInView)
//            }
//        }
//        .onAppear {
//            let authuser = try? AuthenticationManager.shared.getAuthenticatedUser()
//            self.showSignInView = authuser == nil
//        }
//        .fullScreenCover(isPresented: $showSignInView) {
//            NavigationStack {
//                AuthenticationView(showSignInView: $showSignInView)
//            }
//        }
        SettingsView(showSignInView: $showSignInView)
    }
}
