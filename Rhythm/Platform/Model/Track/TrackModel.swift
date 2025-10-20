//
//  TrackModel.swift
//  Rhythm
//
//  Created by Apple on 3/10/25.
//

import Foundation

struct TrackModel: Codable, Identifiable {
    let title: String?
    let artworkUrl: String?
    let bpm: Int?
    let commentCount: Int?
    let commentable: Bool?
    let createdAt: String?
    let description: String?
    let downloadCount: Int?
    let downloadable: Bool?
    let duration: Int
    let favoritingsCount: Int?
    let genre: String?
    let id: Int
    let isrc: String?
    let keySignature: String?
    let kind: String?
    let labelName: String?
    let license: String?
    let permalinkUrl: String?
    let playbackCount: Int?
    let purchaseTitle: String?
    let purchaseUrl: String?
    let release: String?
    let releaseDay: Int?
    let releaseMonth: Int?
    let releaseYear: Int?
    let sharing: String?
    var streamUrl: String?
    let streamable: Bool?
    let tagList: String?
    let uri: String?
    let user: UserModel?
    let userFavorite: Bool?
    let userPlaybackCount: Int?
    let waveformUrl: String?
    let availableCountryCodes: String?
    let access: String?
    let downloadUrl: String?
    let repostsCount: Int?
    let secretUri: String?
    let media: Media?
    
    enum CodingKeys: String, CodingKey {
        case title
        case artworkUrl = "artwork_url"
        case bpm
        case commentCount = "comment_count"
        case commentable
        case createdAt = "created_at"
        case description
        case downloadCount = "download_count"
        case downloadable
        case duration
        case favoritingsCount = "favoritings_count"
        case genre
        case id
        case isrc
        case keySignature = "key_signature"
        case kind
        case labelName = "label_name"
        case license
        case permalinkUrl = "permalink_url"
        case playbackCount = "playback_count"
        case purchaseTitle = "purchase_title"
        case purchaseUrl = "purchase_url"
        case release
        case releaseDay = "release_day"
        case releaseMonth = "release_month"
        case releaseYear = "release_year"
        case sharing
        case streamUrl = "stream_url"
        case streamable
        case tagList = "tag_list"
        case uri
        case user
        case userFavorite = "user_favorite"
        case userPlaybackCount = "user_playback_count"
        case waveformUrl = "waveform_url"
        case availableCountryCodes = "available_country_codes"
        case access
        case downloadUrl = "download_url"
        case repostsCount = "reposts_count"
        case secretUri = "secret_uri"
        case media
    }
}

struct Media: Codable {
    let transcodings: [Transcoding]
    
    enum CodingKeys: CodingKey {
        case transcodings
    }
}

struct Transcoding: Codable {
    let url: String
    let format: Format
    
    enum CodingKeys: CodingKey {
        case url
        case format
    }
}

struct Format: Codable {
    let `protocol`: String
    
    enum CodingKeys: String, CodingKey {
        case `protocol` = "protocol"
    }
}
