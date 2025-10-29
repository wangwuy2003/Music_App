//
//  APIGetPlaylistTracks.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import Foundation

class APIGetPlaylistTracks: APIClient {
    typealias Model = JamendoPlaylistTracksResponse

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }
    var path: String { "/playlists/tracks" }
    var method: HTTPMethod { .get }
    var encoding: ParameterEncoding { .url }

    var clientId: String
    var playlistId: String
    
    init(
        clientId: String = Constant.clientId1,
        playlistId: String
    ) {
        self.clientId = clientId
        self.playlistId = playlistId
    }
    
    var params: [String: Any] {
        return [
            "client_id": clientId,
            "id": playlistId 
        ]
    }
}
