//
//  JamendoAlbum.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//

import Foundation

struct JamendoAlbum: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let artistName: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artistName = "artist_name"
        case image
    }
}

struct JamendoAlbumTracksResponse: Codable {
    let results: [AlbumData]
        
    struct AlbumData: Codable, Identifiable {
        let id: String
        let name: String
        let artistName: String
        let image: String
        let tracks: [JamendoTrack]
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case artistName = "artist_name"
            case image
            case tracks
        }
    }
}
