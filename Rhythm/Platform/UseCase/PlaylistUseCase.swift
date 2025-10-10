//
//  PlaylistUseCase.swift
//  Rhythm
//
//  Created by Apple on 4/10/25.
//

import Foundation

protocol PlaylistUseCaseProtocol {
    func fetchTracksFromPlaylist(playlistId: Int) async throws -> PlaylistTracksModel
}

class PlaylistUseCase: PlaylistUseCaseProtocol {
    func fetchTracksFromPlaylist(playlistId: Int) async throws -> PlaylistTracksModel {
        let client = APIPlaylist(playlistId: playlistId)
        
        return try await withCheckedThrowingContinuation { continuation in
            client.execute { result in
                switch result {
                case .success(let playlist):
                    continuation.resume(returning: playlist)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
