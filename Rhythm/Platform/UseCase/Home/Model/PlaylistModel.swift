//
//  PlaylistModel.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

struct PlaylistModel: Codable, Hashable {
    let id: Int
    let title: String
    let artworkURL: String?
    let trackCount: Int
    let likesCount: Int
    let duration: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case artworkURL = "artwork_url"
        case trackCount = "track_count"
        case likesCount = "likes_count"
        case duration
    }
}
