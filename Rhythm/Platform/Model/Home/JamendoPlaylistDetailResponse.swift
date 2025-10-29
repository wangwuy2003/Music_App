//
//  JamendoPlaylistDetailResponse.swift
//  Rhythm
//
//  Created by Apple on 29/10/25.
//


import Foundation

struct JamendoPlaylistDetailResponse: Codable {
    let headers: ResponseHeaders
    let results: [JamendoPlaylistDetail]
}

struct JamendoPlaylistDetail: Codable, Identifiable, Hashable {
    let id: String
    let name: String?
    let userName: String?
  
    let tracks: [JamendoTrack]? 

    var coverImageFromTrack: String? {
        tracks?.first?.image
    }

    enum CodingKeys: String, CodingKey {
        case id, name, tracks
        case userName = "user_name"
    }
}

