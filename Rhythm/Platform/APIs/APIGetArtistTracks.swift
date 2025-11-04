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
    var artistId: String
    
    init(
        clientId: String = Constant.clientId1,
        artistId: String
    ) {
        self.clientId = clientId
        self.artistId = artistId
    }
    
    var params: [String : Any] {
        return [
            "client_id": clientId,
            "id": artistId
        ]
    }
}
