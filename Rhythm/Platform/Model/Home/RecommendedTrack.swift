//
//  RecommendedTrack.swift
//  Rhythm
//
//  Created by Apple on 10/11/25.
//
import Foundation

struct RecommendedTrack: Codable, Identifiable {
    let id: String
    let name: String
    let artistName: String
    let image: String
    let audio: String
    let audioDownload: String
    let similarity: Double
}

struct SimilarTracksResponse: Codable {
    let track_id: String
    let recommendations: [RecommendedTrack]
}

extension RecommendedTrack {
    func toJamendoTrack() -> JamendoTrack {
        return JamendoTrack(
            id: id,
            name: name,
            albumId: nil,
            duration: nil,
            artistName: artistName,
            albumImage: image,
            image: image,
            audio: audio,
            audioDownload: audioDownload
        )
    }
}
