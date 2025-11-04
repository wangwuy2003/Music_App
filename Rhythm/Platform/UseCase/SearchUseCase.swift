//
//  SearchUseCase.swift
//  Rhythm
//
//  Created by MacMini A6 on 3/11/25.
//

import Foundation

struct SearchUseCase {
    // MARK: - Search Tracks
    func searchTracks(name: String) async throws -> [JamendoTrack] {
        let client = APIGetTracksSearch(nameSearch: name)
        do {
            let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<JamendoTracksResponse, Error>) in
                client.execute { result in
                    switch result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            return response.results
            
        } catch let decoding as DecodingError {
            print("❌ [SearchUseCase] Decoding error (Tracks):", decoding.localizedDescription)
            throw decoding
        } catch {
            print("❌ [SearchUseCase] API error searchTracks:", error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Search Artists
    func searchArtists(name: String) async throws -> [JamendoArtist] {
        let client = APIGetArtistsBySearch(nameSearch: name)
        let response = try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<JamendoResponse<JamendoArtist>, Error>) in
            client.execute { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        return response.results
    }
    
    // MARK: - Search Albums
    func searchAlbums(name: String) async throws -> [JamendoAlbum] {
        let client = APIGetAlbumsBySearch(nameSearch: name)
        let response = try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<JamendoResponse<JamendoAlbum>, Error>) in
            client.execute { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        return response.results
    }
    
    // MARK: - Search Playlists
    func searchPlaylists(name: String) async throws -> [JamendoPlaylistMetadata] {
        let client = APIGetPlaylistsBySearch(nameSearch: name)
        let response = try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<JamendoResponse<JamendoPlaylistMetadata>, Error>) in
            client.execute { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        return response.results
    }
}

