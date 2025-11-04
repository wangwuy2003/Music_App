//
//  JamendoArtistTrackResponse.swift
//  Rhythm
//
//  Created by MacMini A6 on 3/11/25.
//

import Foundation

struct JamendoArtistTracksResponse: Codable {
    let headers: ResponseHeaders
    let results: [JamendoArtistDetail]
}

struct JamendoArtistDetail: Codable, Identifiable {
    let id: String
    let name: String
    let website: String?
    let joinDate: String?
    let image: String?
    let tracks: [JamendoTrack]
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case website
        case joinDate
        case image
        case tracks
    }
}

struct JamendoArtist: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let image: String?
    let website: String?
}

