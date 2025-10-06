//
//  PlaylistUseCase.swift
//  Rhythm
//
//  Created by Apple on 4/10/25.
//

import Foundation
import Combine

protocol PlaylistUseCaseProtocol {
    func fetchTracksFromPlaylist(playlistId: Int) -> AnyPublisher<PlaylistTracksModel, Error>
}

class PlaylistUseCase: PlaylistUseCaseProtocol {
    func fetchTracksFromPlaylist(playlistId: Int) -> AnyPublisher<PlaylistTracksModel, any Error> {
        let client = APIPlaylist(playlistId: playlistId)
         
        return Future<PlaylistTracksModel, Error> { promise in
            client.execute { result in
                switch result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .eraseToAnyPublisher()
    }
}
