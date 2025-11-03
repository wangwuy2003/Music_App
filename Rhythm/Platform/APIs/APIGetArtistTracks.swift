//
//  APIGetArtistTracks.swift
//  Rhythm
//
//  Created by MacMini A6 on 3/11/25.
//
import Foundation

// MARK: Get artist track
class APIGetArtistTracks: APIClient {
    typealias Model = JamendoArtistTracksResponse
    
    var enviroment: any APIEnvironment {
        BaseAPIEnviroment()
    }
    
    var path: String {
        return "/artists/tracks"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return .url
    }
    
    var clientId: String
    var artistName: String
    
    init(
        clientId: String = Constant.clientId1,
        artistName: String
    ) {
        self.clientId = clientId
        self.artistName = artistName
    }
    
    var params: [String : Any] {
        return [
            "client_id": clientId,
            "name": artistName
        ]
    }
}
