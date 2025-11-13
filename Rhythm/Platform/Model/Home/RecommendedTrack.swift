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
    let reason: String?

    enum CodingKeys: String, CodingKey {
        case id, name, artistName, image, audio, audioDownload
        case similarity
        case score_cf
        case reason
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        artistName = try container.decodeIfPresent(String.self, forKey: .artistName) ?? "Unknown"
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        audio = try container.decodeIfPresent(String.self, forKey: .audio) ?? ""
        audioDownload = try container.decodeIfPresent(String.self, forKey: .audioDownload) ?? ""
        similarity = try container.decodeIfPresent(Double.self, forKey: .similarity)
            ?? (try container.decodeIfPresent(Double.self, forKey: .score_cf) ?? 0)
        reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(artistName, forKey: .artistName)
        try container.encode(image, forKey: .image)
        try container.encode(audio, forKey: .audio)
        try container.encode(audioDownload, forKey: .audioDownload)
        try container.encode(similarity, forKey: .similarity)
        try container.encode(reason, forKey: .reason)
    }
}

struct SimilarTracksResponse: Codable {
    let track_id: String
    let recommendations: [RecommendedTrack]
}

struct CFRecommendationsResponse: Codable {
    let user_id: String
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
            audioDownload: audioDownload,
            reason: reason
        )
    }
}
