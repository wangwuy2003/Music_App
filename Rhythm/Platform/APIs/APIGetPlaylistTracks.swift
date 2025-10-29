//
//  APIGetPlaylistTracks.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import Foundation

class APIGetPlaylistTracks: APIClient {
    typealias Model = JamendoResponse<JamendoTrack>

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }
    var path: String { "/playlists/tracks" }
    var method: HTTPMethod { .get }
    var encoding: ParameterEncoding { .url }

    var clientId: String
    var playlistId: String
    var limit: Int?
    
    init(
        clientId: String = Constant.clientId1,
        playlistId: String,
        limit: Int? = nil
    ) {
        self.clientId = clientId
        self.playlistId = playlistId
        self.limit = limit
    }
    
    var params: [String: Any] {
//        return [
//            "client_id": clientId,
//            "format": format,
//            "id": playlistId 
//        ]
        var p: [String: Any] = [
            "client_id": clientId,
            "id": playlistId
        ]
        
        if let limit = limit { 
            p["limit"] = limit
        }
        
        return p
    }
}
