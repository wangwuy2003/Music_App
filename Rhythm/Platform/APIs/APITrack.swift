//
//  APITrack.swift
//  Rhythm
//
//  Created by Apple on 7/10/25.
//

import Foundation

class APITrack: APIClient {
    
    typealias Model = TrackModel

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }

    var clientId: String
    let trackId: Int

    init(
        clientId: String = Constant.clientId,
        trackId: Int
    ) {
        self.clientId = clientId
        self.trackId = trackId
    }
    
    var path: String {
        return "tracks/\(trackId)"
    }

    var params: [String: Any] {
        return [
            "client_id": clientId
        ]
    }

    var encoding: ParameterEncoding {
        return .url
    }
    
    var method: HTTPMethod { .get }
}

