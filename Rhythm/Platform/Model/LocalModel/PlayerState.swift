//
//  PlayerState.swift
//  Rhythm
//
//  Created by Apple on 1/11/25.
//
import Foundation

struct PlayerState: Codable {
    let currentTrack: JamendoTrack
    let currentTime: Double
    let currentQueue: [JamendoTrack]
    let currentIndex: Int
}
