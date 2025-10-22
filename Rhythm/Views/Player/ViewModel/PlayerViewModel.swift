//
//  PlayerViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 24/9/25.
//

import SwiftUI

class PlayerViewModel: ObservableObject {
    @Published var isExpanded: Bool = false
    @Published var selectedTrack: TrackModel? = nil
}
