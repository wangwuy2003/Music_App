//
//  Untitled.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation
import FirebaseFirestore

class HomeUseCase {
    // MARK: - Fetch Top Albums
    func fetchTopAlbums() async throws -> [JamendoAlbum] {
        let client = APIGetTopAlbums()
        
        do {
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
            return response.results
            
        } catch let decoding as DecodingError {
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
        let client = APIGetPlaylistsByID(limit: 20, ids: ids)
        
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
        let client = APIGetTopTracks()
        
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
    
    // MARK: - Fetch Tracks For Artist
    func fetchTracks(forArtistID artistId: String) async throws -> [JamendoTrack] {
        let client = APIGetArtistTracks(artistId: artistId)
        
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
            
            return response.results.first?.tracks ?? []
            
        } catch let decoding as DecodingError {
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
            print("❌ API error fetchTracks forArtistID '\(artistId)':", error.localizedDescription)
            throw error
        }
    }
    
    // MARK: Fetch Tracks Playlist
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

// MARK: fast api
extension HomeUseCase {
    
    func fetchSimilarTracks(for trackId: String) async throws -> [JamendoTrack] {
        guard let url = URL(string: "https://nikolai-unthrashed-almeda.ngrok-free.dev/recommend?track_id=\(trackId)") else {
            print("❌ URL không hợp lệ cho track ID: \(trackId)")
            return []
        }

        print("🌐 [API] Fetching similar tracks for track_id = \(trackId)...")

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 [API] HTTP \(httpResponse.statusCode) từ \(url.absoluteString)")
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                print("🧩 [API] JSON Response:", json)
                
                // Nếu có lỗi từ server (ví dụ: {"error": "Không tìm thấy..."})
                if let errorMsg = json["error"] as? String {
                    print("⚠️ [API] Server error message:", errorMsg)
                    return [] // ✅ Không crash, chỉ trả về mảng rỗng
                }
            }

            let decoded = try JSONDecoder().decode(SimilarTracksResponse.self, from: data)
            let jamendoTracks = decoded.recommendations.map { $0.toJamendoTrack() }

            print("✅ [API] Decode thành công: \(jamendoTracks.count) tracks.")
            return jamendoTracks

        } catch let decodingError as DecodingError {
            print("❌ [Decode Error] \(decodingError)")
            return [] // ✅ Không throw nữa — chỉ trả về rỗng
        } catch {
            print("❌ [API Error] Không thể fetch similar tracks:", error.localizedDescription)
            return [] // ✅ Không throw — app không crash
        }
    }

    func fetchRecentMixes() async throws -> [PersonalMix] {
        let recentIds = UserDefaults.standard.array(forKey: "recentlyPlayed") as? [String] ?? []
        var mixes: [PersonalMix] = []
        
        for id in recentIds {
            do {
                // 🔹 Lấy bài hát gốc từ Jamendo
                let baseTrackURL = URL(string: "https://api.jamendo.com/v3.0/tracks/?client_id=\(Constant.clientId1)&format=json&id=\(id)")!
                let (baseData, _) = try await URLSession.shared.data(from: baseTrackURL)
                let baseResponse = try JSONDecoder().decode(JamendoResponse<JamendoTrack>.self, from: baseData)
                guard let baseTrack = baseResponse.results.first else { continue }
                
                // 🔹 Lấy các bài tương tự từ API ngrok
                let similar = try await fetchSimilarTracks(for: id)
                
                let mix = PersonalMix(id: id, baseTrack: baseTrack, similarTracks: similar)
                mixes.append(mix)
                
            } catch {
                print("⚠️ Bỏ qua lỗi khi tạo mix cho \(id):", error.localizedDescription)
                continue
            }
        }
        return mixes
    }
    
    func fetchMixForSingleTrack(trackId: String) async throws -> PersonalMix {
        // 🔹 Lấy bài hát gốc
        let baseTrackURL = URL(string: "https://api.jamendo.com/v3.0/tracks/?client_id=\(Constant.clientId1)&format=json&id=\(trackId)")!
        let (baseData, _) = try await URLSession.shared.data(from: baseTrackURL)
        let baseResponse = try JSONDecoder().decode(JamendoResponse<JamendoTrack>.self, from: baseData)
        guard let baseTrack = baseResponse.results.first else {
            throw NSError(domain: "MixError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Không tìm thấy bài \(trackId)"])
        }

        // 🔹 Lấy các bài tương tự từ API ngrok
        let similar = try await fetchSimilarTracks(for: trackId)
        return PersonalMix(id: trackId, baseTrack: baseTrack, similarTracks: similar)
    }
    
    func fetchPersonalRecommendations(for uid: String) async throws -> [JamendoTrack] {
        let urlString = "https://nikolai-unthrashed-almeda.ngrok-free.dev/reco/home?user_id=\(uid)"
        guard let url = URL(string: urlString) else { return [] }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(CFRecommendationsResponse.self, from: data)
        return decoded.recommendations.map { $0.toJamendoTrack() }
    }
}
