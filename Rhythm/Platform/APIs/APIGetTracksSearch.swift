//
//  Untitled.swift
//  Rhythm
//
//  Created by MacMini A6 on 3/11/25.
//
import Foundation

class APIGetTracksSearch: APIClient {
    typealias Model = JamendoTracksResponse

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }
    var path: String { "/tracks" }
    var method: HTTPMethod { .get }
    var encoding: ParameterEncoding { .url }

    var clientId: String
    var nameSearch: String
    var limit: Int
    
    init(
        clientId: String = Constant.clientId1,
        nameSearch: String,
        limit: Int = 10
    ) {
        self.clientId = clientId
        self.nameSearch = nameSearch
        self.limit = limit
    }
    
    var params: [String: Any] {
        return [
            "client_id": clientId,
            "namesearch": nameSearch,
            "limit": limit
        ]
    }
}
