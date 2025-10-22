//
//  Music_AppApp.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

@main
struct RhythmApp: App {
    var body: some Scene {
        WindowGroup {
//            RouterView(addNavigationStack: false, addModuleSupport: true   ) { _ in
//                RootView {
//                    TabbarView()
//                        .preferredColorScheme(.dark)
//                }
//            }
            
            RootView {
                TabbarView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
