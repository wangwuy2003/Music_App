//
//  SavedTrack.swift
//  Rhythm
//
//  Created by MacMini A6 on 31/10/25.
//

import Foundation
import SwiftData

@Model
final class SavedTrack {
    @Attribute(.unique) var jamendoID: String
    var name: String
    var artistName: String?
    var imageURL: String?
    var audioURL: String?
    var duration: Int?
    
    @Relationship(inverse: \Playlist.tracks)
    var playlist: Playlist
    
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

