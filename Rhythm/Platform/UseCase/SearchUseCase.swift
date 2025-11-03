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
    func searchArtistTracks(name: String) async throws -> JamendoArtistDetail? {
        let client = APIGetArtistTracks(artistName: name)
        
        do {
            let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<JamendoArtistTracksResponse, Error>) in
                client.execute { result in
                    switch result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            return response.results.first
            
        } catch let decoding as DecodingError {
            print("❌ [SearchUseCase] Decoding error (Artist):", decoding.localizedDescription)
            throw decoding
        } catch {
            print("❌ [SearchUseCase] API error searchArtistTracks:", error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Search Albums
    func searchAlbums(artistName: String) async throws -> [JamendoAlbum] {
        let client = APIGetAlbumTracks(artistName: artistName)
        
        do {
            let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<JamendoAlbumTracksResponse, Error>) in
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
            print("❌ [SearchUseCase] Decoding error (Albums):", decoding.localizedDescription)
            throw decoding
        } catch {
            print("❌ [SearchUseCase] API error searchAlbums:", error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Search Playlists
        func searchPlaylists(name: String) async throws -> [JamendoPlaylistDetail] {
            let client = APIGetPlaylistTracks(playlistId: name)
            
            do {
                let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<JamendoPlaylistTracksResponse, Error>) in
                    client.execute { result in
                        switch result {
                        case .success(let value):
                            continuation.resume(returning: value)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
                return response.results.map { JamendoPlaylistDetail(id: $0.id, name: $0.name ?? "Unknown", image: nil) }
                
            } catch let decoding as DecodingError {
                print("❌ [SearchUseCase] Decoding error (Playlists):", decoding.localizedDescription)
                throw decoding
            } catch {
                print("❌ [SearchUseCase] API error searchPlaylists:", error.localizedDescription)
                throw error
            }
        }
}

