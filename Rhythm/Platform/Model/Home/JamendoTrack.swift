//
//  JamendoTrack.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//
import Foundation

struct JamendoTrack: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let albumId: String?
    let duration: Int?
    let artistName: String?
    let playlistadddate: String?
    let position: Int?
    let licenseCcurl: String?
    let albumImage: String?
    let image: String?
    let audio: String?
    let audioDownload: String?
    let audioDownloadAllowed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case albumId = "album_id"
        case duration
        case artistName = "artist_name"
        case playlistadddate
        case position
        case licenseCcurl = "license_ccurl"
        case albumImage = "album_image"
        case image
        case audio
        case audioDownload = "audiodownload"
        case audioDownloadAllowed = "audiodownload_allowed"
    }
}
