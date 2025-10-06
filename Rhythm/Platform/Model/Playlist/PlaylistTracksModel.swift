//
//  PlaylistTracksModel.swift
//  Rhythm
//
//  Created by Apple on 4/10/25.
//

import Foundation

class PlaylistTracksModel: Codable {
    let artworkUrl: String
    let createdAt: String
    let duration: Int
    let id: Int
    let kind: String
    let lastModified: String
    let likesCount: Int
    let managedByFeeds: Bool
    let permalink: String
    let permalinkUrl: String
    let isPublic: Bool
    let repostsCount: Int
    let secretToken: String?
    let sharing: String
    let title: String
    let trackCount: Int
    let uri: String
    let userId: Int
    let setType: String
    let isAlbum: Bool
    let publishedAt: String?
    let releaseDate: String?
    let displayDate: String?
    let user: UserModel
    let tracks: [TrackModel]

    enum CodingKeys: String, CodingKey {
        case artworkUrl = "artwork_url"
        case createdAt = "created_at"
        case duration
        case id
        case kind
        case lastModified = "last_modified"
        case likesCount = "likes_count"
        case managedByFeeds = "managed_by_feeds"
        case permalink
        case permalinkUrl = "permalink_url"
        case isPublic = "public"
        case repostsCount = "reposts_count"
        case secretToken = "secret_token"
        case sharing
        case title
        case trackCount = "track_count"
        case uri
        case userId = "user_id"
        case setType = "set_type"
        case isAlbum = "is_album"
        case publishedAt = "published_at"
        case releaseDate = "release_date"
        case displayDate = "display_date"
        case user
        case tracks
    }
}
