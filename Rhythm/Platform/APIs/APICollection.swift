//
//  APICollection.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation
class APICollection: APIClient {
    
    typealias Model = FeedResponse

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }

    var clientId: String
    var limit: Int
    var format: String

    init(
        clientId: String = Constant.clientId1,
        limit: Int = 20,
        format: String = "json"
    ) {
        self.clientId = clientId
        self.limit = limit
        self.format = format
    }
    
    var path: String {
        return "/feeds"
    }

    var params: [String: Any] {
        return [
            "client_id": clientId,
            "limit": limit,
            "format": format
        ]
    }

    var encoding: ParameterEncoding {
        return .url
    }
    var method: HTTPMethod { .get }
}
