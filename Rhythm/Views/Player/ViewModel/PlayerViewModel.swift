//
//  PlayerViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 24/9/25.
//

import SwiftUI

class PlayerViewModel: ObservableObject {
    
    @Published var isBarPresented: Bool = true   // hiện mini bar
    @Published var isPopupOpen: Bool = false      // mở full player

    @Published var title: String = "Not Playing"
    @Published var subtitle: String = ""
    @Published var artwork: String? = nil
    @Published var progress: Double = 0           // 0...1

    func start(track: Track) {
        title = track.title
        subtitle = track.artist
        artwork = track.cover
        isBarPresented = true
        // isPopupOpen = true  // nếu muốn mở full ngay
    }
}
