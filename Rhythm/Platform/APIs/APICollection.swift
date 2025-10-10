//
//  APICollection.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation
class APICollection: APIClient {
    
    typealias Model = CollectionResponseModel

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }

    var clientId: String
    var limit: Int
    var offset: Int
    var linkedPartitioning: Int
    var appVersion: String
    var appLocale: String

    init(
        clientId: String = Constant.clientId,
        limit: Int = 20,
        offset: Int = 0,
        linkedPartitioning: Int = 1,
        appVersion: String = "1753870647",
        appLocale: String = "en"
    ) {
        self.clientId = clientId
        self.limit = limit
        self.offset = offset
        self.linkedPartitioning = linkedPartitioning
        self.appVersion = appVersion
        self.appLocale = appLocale
    }
    var path: String {
        return "/mixed-selections"
    }

    var params: [String: Any] {
        return [
            "client_id": clientId,
            "limit": limit,
            "offset": offset,
            "linked_partitioning": linkedPartitioning,
            "app_version": appVersion,
            "app_locale": appLocale
        ]
    }

    var encoding: ParameterEncoding {
        return .url
    }
    var method: HTTPMethod { .get }
}
