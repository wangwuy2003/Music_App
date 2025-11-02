//
//  FavouriteTrack.swift
//  Rhythm
//
//  Created by Apple on 1/11/25.
//
import Foundation
import SwiftData

@Model
class FavouriteTrack {
    @Attribute(.unique) var jamendoID: String
    var name: String
    var artistName: String?
    var imageURL: String?
    var audioURL: String?
    var duration: Int?
    
    init(jamendoTrack: JamendoTrack) {
        self.jamendoID = jamendoTrack.id
        self.name = jamendoTrack.name
        self.artistName = jamendoTrack.artistName
        self.imageURL = jamendoTrack.image
        self.audioURL = jamendoTrack.audio
        self.duration = jamendoTrack.duration
    }
}

extension FavouriteTrack {
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
