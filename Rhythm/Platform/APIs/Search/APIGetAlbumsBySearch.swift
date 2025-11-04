//
//  APIGetAlbumsBySearch.swift
//  Rhythm
//
//  Created by Apple on 3/11/25.
//

import Foundation

class APIGetAlbumsBySearch: APIClient {
    typealias Model = JamendoResponse<JamendoAlbum>

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }
    var path: String { "/albums" }
    var method: HTTPMethod { .get }
    var encoding: ParameterEncoding { .url }

    var clientId: String
    var nameSearch: String

    init(clientId: String = Constant.clientId1, nameSearch: String) {
        self.clientId = clientId
        self.nameSearch = nameSearch
    }

    var params: [String: Any] {
        [
            "client_id": clientId,
            "namesearch": nameSearch,
            "limit": 10
        ]
    }
}
