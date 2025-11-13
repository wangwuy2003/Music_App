//
//  Playlist.swift
//  Rhythm
//
//  Created by MacMini A6 on 31/10/25.
//

import Foundation
import SwiftData

@Model
final class Playlist {
    var id: UUID
    var name: String
    var playlistDescription: String
    
    @Attribute(.externalStorage)
    var imageData: Data?
    
    @Relationship(deleteRule: .cascade)
    var tracks: [SavedTrack]
    
    init(name: String, playlistDescription: String, imageData: Data? = nil) {
        self.id = UUID()
        self.name = name
        self.playlistDescription = playlistDescription
        self.imageData = imageData
        self.tracks = []
    }
}

@Model
final class SavedTrack {
    @Attribute(.unique) var jamendoID: String
    var name: String
    var artistName: String?
    var imageURL: String?
    var audioURL: String?
    var duration: Int?
    
    @Relationship(inverse: \Playlist.tracks)
    var playlist: Playlist?
    
    init(jamendoTrack: JamendoTrack, playlist: Playlist) {
        self.jamendoID = jamendoTrack.id
        self.name = jamendoTrack.name
        self.artistName = jamendoTrack.artistName
        self.imageURL = jamendoTrack.image
        self.audioURL = jamendoTrack.audio
        self.duration = jamendoTrack.duration
        self.playlist = playlist
    }
}

extension SavedTrack {
    func toJamendoTrack() -> JamendoTrack {
        JamendoTrack(
            id: jamendoID,
            name: name,
            albumId: nil,
            duration: duration,
            artistName: artistName,
            albumImage: imageURL,
            image: imageURL,
            audio: audioURL,
            audioDownload: nil
        )
    }
}

struct PlaylistDraft {
    var name: String
    var description: String
    var imageData: Data?

    init(from playlist: Playlist) {
        self.name = playlist.name
        self.description = playlist.playlistDescription
        self.imageData = playlist.imageData
    }
}
