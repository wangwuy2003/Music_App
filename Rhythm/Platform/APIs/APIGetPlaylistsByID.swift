//
//  APIGetPlaylistsByID.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import Foundation

class APIGetPlaylistsByID: APIClient {
    typealias Model = JamendoResponse<JamendoPlaylist>

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }
    var path: String { "/playlists" }
    var method: HTTPMethod { .get }
    var encoding: ParameterEncoding { .url }

    var clientId: String
    var format: String
    var ids: [String]

    init(
        clientId: String = Constant.clientId1,
        format: String = "json",
        ids: [String]
    ) {
        self.clientId = clientId
        self.format = format
        self.ids = ids
    }
    
    var params: [String: Any] {
        return [
            "client_id": clientId,
            "format": format,
            "id": ids.joined(separator: "+") 
        ]
    }
}
