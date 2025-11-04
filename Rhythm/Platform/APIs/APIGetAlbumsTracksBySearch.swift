//
//  APIGetAlbumsTracksBySearch.swift
//  Rhythm
//
//  Created by Apple on 3/11/25.
//

import Foundation

class APIGetAlbumsTracksBySearch: APIClient {
    typealias Model = JamendoAlbumTracksResponse

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }
    var path: String { "/albums/tracks" }
    var method: HTTPMethod { .get }
    var encoding: ParameterEncoding { .url }

    var clientId: String
    var nameSearch: String
    var limit: Int

    init(clientId: String = Constant.clientId1,
         nameSearch: String,
         limit: Int = 10) {
        self.clientId = clientId
        self.nameSearch = nameSearch
        self.limit = limit
    }

    var params: [String: Any] {
        return [
            "client_id": clientId,
            "limit": limit,
            "namesearch": nameSearch,
            "include": "musicinfo+stats"
        ]
    }
}
