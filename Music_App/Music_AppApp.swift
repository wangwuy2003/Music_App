//
//  Music_AppApp.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI

@main
struct Music_AppApp: App {
    var body: some Scene {
        WindowGroup {
            TabbarView()
                .transition(.move(edge: .top).combined(with: .opacity))
                .preferredColorScheme(.dark)
        }
    }
}
