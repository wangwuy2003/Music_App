//
//  Untitled.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation

class HomeUseCase {
    // MARK: - Fetch Top Albums
    func fetchTopAlbums() async throws -> [JamendoAlbum] {
        // 1. Dùng client APIGetTopAlbums
        let client = APIGetTopAlbums()
        
        do {
            // 2. Dùng withCheckedThrowingContinuation để bọc hàm execute
            let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<JamendoResponse<JamendoAlbum>, Error>) in
                client.execute { result in
                    switch result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            // 3. Trả về mảng .results
            return response.results
            
        } catch let decoding as DecodingError {
            // Log chi tiết (giống hệt code của bạn)
            switch decoding {
            case .keyNotFound(let key, let ctx):
                print("❌ keyNotFound:", key.stringValue, "context:", ctx.debugDescription)
            case .typeMismatch(let type, let ctx):
                print("❌ typeMismatch:", type, "context:", ctx.debugDescription)
            case .valueNotFound(let type, let ctx):
                print("❌ valueNotFound:", type, "context:", ctx.debugDescription)
            case .dataCorrupted(let ctx):
                print("❌ dataCorrupted:", ctx.debugDescription)
            @unknown default:
                print("❌ unknown DecodingError:", decoding)
            }
            throw decoding
        } catch {
            print("❌ API error fetchTopAlbums:", error.localizedDescription)
            throw error
        }
    }
    
    func fetchPlaylists(byIDs ids: [String]) async throws -> [JamendoPlaylistDetail] {
        let client = APIGetPlaylistsByID(ids: ids)
        
        do {
            let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<JamendoPlaylistDetailResponse, Error>) in
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
        } catch {
            print("❌ API error fetchPlaylists byIDs:", error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Fetch Top Tracks
    func fetchTopTracks() async throws -> [JamendoTrack] {
        // 1. Dùng client APIGetTopTracks
        let client = APIGetTopTracks()
        
        do {
            // 2. Dùng withCheckedThrowingContinuation
            let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<JamendoResponse<JamendoTrack>, Error>) in
                client.execute { result in
                    switch result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            // 3. Trả về mảng .results
            return response.results
            
        } catch let decoding as DecodingError {
            // Log chi tiết
            switch decoding {
            case .keyNotFound(let key, let ctx):
                print("❌ keyNotFound:", key.stringValue, "context:", ctx.debugDescription)
                // ... (thêm các case khác như trên)
            default:
                print("❌ unknown DecodingError:", decoding)
            }
            throw decoding
        } catch {
            print("❌ API error fetchTopTracks:", error.localizedDescription)
            throw error
        }
    }
    
    func fetchTracks(forAlbumId albumId: String) async throws -> [JamendoTrack] {
        let client = APIGetAlbumTracks(albumId: albumId)
        
        do {
            let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<JamendoResponse<JamendoTrack>, Error>) in
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
        } catch {
            print("❌ API error fetchTracks forAlbumId '\(albumId)':", error.localizedDescription)
            throw error
        }
    }
    
    func fetchTracks(forPlaylistID playlistId: String) async throws -> [JamendoTrack] {
        let client = APIGetPlaylistTracks(playlistId: playlistId)
        
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
            
            return response.results.first?.tracks ?? []
        } catch let decoding as DecodingError {
            // Log chi tiết (giống hệt code của bạn)
            switch decoding {
            case .keyNotFound(let key, let ctx):
                print("❌ keyNotFound:", key.stringValue, "context:", ctx.debugDescription)
            case .typeMismatch(let type, let ctx):
                print("❌ typeMismatch:", type, "context:", ctx.debugDescription)
            case .valueNotFound(let type, let ctx):
                print("❌ valueNotFound:", type, "context:", ctx.debugDescription)
            case .dataCorrupted(let ctx):
                print("❌ dataCorrupted:", ctx.debugDescription)
            @unknown default:
                print("❌ unknown DecodingError:", decoding)
            }
            throw decoding
        } catch {
            print("❌ API error fetchTracks forPlaylistID '\(playlistId)':", error.localizedDescription)
            throw error
        }
    }
}
