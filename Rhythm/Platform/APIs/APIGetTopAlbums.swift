//
//  APIGetTopAlbums.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//

import Foundation

class APIGetTopAlbums: APIClient {
    typealias Model = JamendoResponse<JamendoAlbum>

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }
    var path: String { "/albums" }
    var method: HTTPMethod { .get }
    var encoding: ParameterEncoding { .url }

    var clientId: String
    var limit: Int
    var format: String
    var order: String

    init(
        clientId: String = Constant.clientId1,
        limit: Int = 20,
        format: String = "json",
        order: String = "popularity_total"
    ) {
        self.clientId = clientId
        self.limit = limit
        self.format = format
        self.order = order
    }
    
    var params: [String: Any] {
        return [
            "client_id": clientId,
            "limit": limit,
            "format": format,
            "order": order
        ]
    }
}
