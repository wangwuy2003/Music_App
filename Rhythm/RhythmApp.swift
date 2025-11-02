//
//  Music_AppApp.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import SwiftData
import UIKit
import YMTGetDeviceName

@main
struct RhythmApp: App {
    @StateObject private var playerVM = PlayerViewModel()
    @StateObject private var homeVM = HomeViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var modelContext
    @State private var showMainView = false
    var body: some Scene {
        WindowGroup {
            if showMainView {
                TabbarView()
                    .environmentObject(playerVM)
                    .environmentObject(homeVM)
                    .preferredColorScheme(.dark)
                    .onAppear {
                        playerVM.attachModelContext(modelContext)
                        playerVM.restoreState()
                    }

            } else {
                SplashView(showMainView: $showMainView)
                    .environmentObject(homeVM)
            }
            
        }
        .modelContainer(for: [Playlist.self, SavedTrack.self, FavouriteTrack.self])
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                playerVM.saveState()
            }
        }
    }
}


