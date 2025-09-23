//
//  Track.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//
import Foundation
import SwiftUI

struct Track: Identifiable {
    let id = UUID().uuidString
    let title: String
    let artist: String
    let duration: String
    let playCount: String
    let cover: String
    
    static let sample: [Track] = Array(repeating: Track(
        title: "Vaina loca - osuna",
        artist: "Aura",
        duration: "3:04",
        playCount: "3.5M",
        cover: "coverImage"
    ), count: 20)
}
