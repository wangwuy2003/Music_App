//
//  APIPlaylist.swift
//  Rhythm
//
//  Created by Apple on 4/10/25.
//

//import Foundation
//
//struct APIPlaylist: APIClient {
//    typealias Model = PlaylistTracksModel
//    
//    let playlistId: Int 
//    
//    var enviroment: any APIEnvironment {
//        BaseAPIEnviroment()
//    }
//    
//    var headers: [String: String] {
//        return enviroment.headers
//    }
//    
//    var params: [String: Any] {
//        return [
//            "client_id": Constant.clientId
//        ]
//    }
//    
//    var path: String {
//        return "playlists/\(playlistId)"
//    }
//    
//    var method: HTTPMethod {
//        return .get
//    }
//}

import Foundation
class APIPlaylist: APIClient {
    
    typealias Model = PlaylistTracksModel

    var enviroment: any APIEnvironment { BaseAPIEnviroment() }

    var clientId: String
    let playlistId: Int

    init(
        clientId: String = Constant.clientId,
        playlistId: Int
    ) {
        self.clientId = clientId
        self.playlistId = playlistId
    }
    var path: String {
        return "playlists/\(playlistId)"
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
