//
//  APIGetAlbumTracks.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//

import Foundation

class APIGetAlbumTracks: APIClient {
    typealias Model = JamendoResponse<JamendoTrack>

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }
    var path: String { "/tracks" }
    var method: HTTPMethod { .get }
    var encoding: ParameterEncoding { .url }

    var clientId: String
    var format: String
    var albumId: String

    init(
        clientId: String = Constant.clientId1,
        format: String = "json",
        albumId: String
    ) {
        self.clientId = clientId
        self.format = format
        self.albumId = albumId
    }
    
    var params: [String: Any] {
        return [
            "client_id": clientId,
            "format": format,
            "album_id": albumId
        ]
    }
}
