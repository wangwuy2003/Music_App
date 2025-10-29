//
//  JamendoPlaylist.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import Foundation

struct JamendoPlaylist: Codable, Identifiable, Hashable {
    let id: String
    let name: String?
    let image: String?
    let userName: String?
    let tracks: [JamendoTrack]?
    
    var coverImageFromTrack: String? {
        tracks?.first?.image
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, tracks
        case userName = "user_name"
    }
}
