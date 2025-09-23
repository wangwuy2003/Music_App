//
//  Music_AppApp.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI

@main
struct RhythmApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                TabbarView()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .preferredColorScheme(.dark)
            }
           
        }
    }
}
