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
