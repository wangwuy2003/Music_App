//
//  HomeViewModel.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation
import SwiftfulRouting

@MainActor
class HomeViewModel: ObservableObject {
    let homeUseCase = UseCaseProvider.makeHomeUseCase()
    
    @Published var topAlbums: [JamendoAlbum] = []
    @Published var topTracks: [JamendoTrack] = []
    @Published var popularPlaylists: [JamendoPlaylistDetail] = []
    @Published var similarMix: [JamendoTrack] = []
    @Published var personalMix: [JamendoTrack] = []
    @Published var recentMixes: [PersonalMix] = []
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func fetchData() async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            async let albumsTask = homeUseCase.fetchTopAlbums()
            async let tracksTask = homeUseCase.fetchTopTracks()
            
            async let playlistsTask = homeUseCase.fetchPlaylists(byIDs: Constant.featuredPlaylistIDs)
            
            topAlbums = try await albumsTask
            topTracks = try await tracksTask
            
            popularPlaylists = try await playlistsTask
            
            print("✅ Đã tải: \(topAlbums.count) albums, \(topTracks.count) tracks")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Yolo API Error:", error.localizedDescription)
        }
    }
    
    func fetchSimilarMix(playerVM: PlayerViewModel? = nil) async {
        do {
            // 1️⃣ Ưu tiên bài đang phát (nếu có PlayerViewModel truyền vào)
            if let currentTrack = playerVM?.currentTrack {
                print("🎧 Lấy Mix dựa trên bài đang phát: \(currentTrack.name)")
                let similar = try await homeUseCase.fetchSimilarTracks(for: currentTrack.id)
                self.similarMix = similar
                print("✅ Loaded \(similar.count) tracks for mix giống bài: \(currentTrack.name)")
                return
            }

            // 2️⃣ Nếu không có playerVM hoặc currentTrack, dùng bài phát cuối cùng từ UserDefaults
            if let lastPlayedId = UserDefaults.standard.string(forKey: "lastPlayedTrackID"),
               !lastPlayedId.isEmpty {
                let lastPlayedName = UserDefaults.standard.string(forKey: "lastPlayedTrackName") ?? "Unknown"
                print("📀 Lấy Mix dựa trên bài phát cuối cùng: \(lastPlayedName) [\(lastPlayedId)]")

                let similar = try await homeUseCase.fetchSimilarTracks(for: lastPlayedId)
                self.similarMix = similar
                print("✅ Loaded \(similar.count) tracks for mix giống bài: \(lastPlayedName)")
                return
            }

            // 3️⃣ Nếu vẫn không có, fallback sang bài đầu tiên trong topTracks
            guard let firstTrack = topTracks.first else {
                print("⚠️ Không có bài hát nào để làm Mix")
                return
            }

            print("🎵 Fallback: Lấy Mix theo bài đầu tiên \(firstTrack.name)")
            let similar = try await homeUseCase.fetchSimilarTracks(for: firstTrack.id)
            self.similarMix = similar
            print("✅ Loaded \(similar.count) tracks for mix giống bài: \(firstTrack.name)")

        } catch {
            print("❌ Lỗi fetchSimilarMix:", error.localizedDescription)
        }
    }
    
    func fetchPersonalMix() async {
        do {
            let mix = try await homeUseCase.fetchPersonalMix()
            await MainActor.run {
                self.personalMix = mix
            }
        } catch {
            print("❌ Lỗi fetchPersonalMix:", error.localizedDescription)
        }
    }
    
    func fetchRecentMixes() async {
        do {
            let mixes = try await homeUseCase.fetchRecentMixes()
            let filtered = mixes.filter { !$0.similarTracks.isEmpty } // ✅ bỏ mix trống
            await MainActor.run {
                self.recentMixes = filtered
            }
            print("✅ Tạo \(filtered.count) playlists mix hợp lệ dựa trên recent tracks")
        } catch {
            print("❌ Lỗi fetchRecentMixes:", error.localizedDescription)
        }
    }


}
