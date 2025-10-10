//
//  TrackUseCase.swift
//  Rhythm
//
//  Created by Apple on 5/10/25.
//
import SwiftUI
import Combine

protocol TrackUseCaseProtocol {
    func fechTrack(trackId: Int) async throws -> TrackModel
}

class TrackUseCase: TrackUseCaseProtocol {
    func fechTrack(trackId: Int) async throws -> TrackModel {
        let client = APITrack(trackId: trackId)
        
        return try await withCheckedThrowingContinuation { continuation in
            client.execute { result in
                switch result {
                case .success(let track):
                    continuation.resume(returning: track)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
