//
//  Music_AppApp.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import SwiftData

@main
struct RhythmApp: App {
    var body: some Scene {
        WindowGroup {
            RouterView(addNavigationStack: false, addModuleSupport: true) { _ in
                TabbarView()
                    .preferredColorScheme(.dark)
            }
        }
        .modelContainer(for: [Playlist.self, SavedTrack.self])
    }
}
