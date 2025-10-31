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
    let albumImage: String?
    let image: String?
    let audio: String?
    let audioDownload: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case albumId = "album_id"
        case duration
        case artistName = "artist_name"
        case albumImage = "album_image"
        case image
        case audio
        case audioDownload = "audiodownload"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        albumId = try? container.decode(String.self, forKey: .albumId)
        artistName = try? container.decode(String.self, forKey: .artistName)
        albumImage = try? container.decode(String.self, forKey: .albumImage)
        image = try? container.decode(String.self, forKey: .image)
        audio = try? container.decode(String.self, forKey: .audio)
        audioDownload = try? container.decode(String.self, forKey: .audioDownload)
        
        if let durationString = try? container.decode(String.self, forKey: .duration),
           let durationValue = Int(durationString) {
            duration = durationValue
        } else {
            duration = try? container.decode(Int.self, forKey: .duration)
        }
    }
    
    init(
        id: String,
        name: String,
        albumId: String? = nil,
        duration: Int? = nil,
        artistName: String? = nil,
        albumImage: String? = nil,
        image: String? = nil,
        audio: String? = nil,
        audioDownload: String? = nil
    ) {
        self.id = id
        self.name = name
        self.albumId = albumId
        self.duration = duration
        self.artistName = artistName
        self.albumImage = albumImage
        self.image = image
        self.audio = audio
        self.audioDownload = audioDownload
    }
}

