//
//  PersonalMix.swift
//  Rhythm
//
//  Created by Apple on 10/11/25.
//


import Foundation

struct PersonalMix: Identifiable, Hashable {
    let id: String        // chính là track_id gốc
    let baseTrack: JamendoTrack
    let similarTracks: [JamendoTrack]
}
