//
//  APIGetTopTracks.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//

import Foundation

class APIGetTopTracks: APIClient {
    typealias Model = JamendoResponse<JamendoTrack>

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }
    var path: String { "/tracks" }
    var method: HTTPMethod { .get }
    var encoding: ParameterEncoding { .url }

    // 2. Các tham số đầu vào
    var clientId: String
    var limit: Int
    var format: String
    var order: String

    init(
        clientId: String = Constant.clientId1,
        limit: Int = 10,
        format: String = "json",
        order: String = "popularity_week"
    ) {
        self.clientId = clientId
        self.limit = limit
        self.format = format
        self.order = order
    }
    
    // 3. Danh sách params cho URL
    var params: [String: Any] {
        return [
            "client_id": clientId,
            "limit": limit,
            "format": format,
            "order": order
        ]
    }
}
