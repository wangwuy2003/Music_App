//
//  JamendoPlaylistTracksResponse.swift
//  Rhythm
//
//  Created by Apple on 29/10/25.
//

struct JamendoPlaylistTracksResponse: Codable {
    let headers: ResponseHeaders
    let results: [JamendoPlaylistWithTracks]
}

struct JamendoPlaylistWithTracks: Codable, Identifiable {
    let id: String
    let name: String
    let tracks: [JamendoTrack]
}
