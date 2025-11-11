//
//  HomeViewModel.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation
import SwiftfulRouting
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    let homeUseCase = UseCaseProvider.makeHomeUseCase()
    
    @Published var topAlbums: [JamendoAlbum] = []
    @Published var topTracks: [JamendoTrack] = []
    @Published var popularPlaylists: [JamendoPlaylistDetail] = []
    @Published var recentMixes: [PersonalMix] = []
    
    @Published var isRefreshing: Bool = false
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
    
    func fetchRecentMixes() async {
        do {
            let mixes = try await homeUseCase.fetchRecentMixes()
            let filtered = mixes.filter { !$0.similarTracks.isEmpty }

            withAnimation(.easeOut(duration: 0.25)) {
                self.recentMixes = filtered
            }

            await MainActor.run {
                self.saveCache()
            }

            print("✅ Cập nhật recent mixes: \(filtered.count) playlists.")
        } catch {
            print("❌ Lỗi fetchRecentMixes:", error.localizedDescription)
        }
    }
    
    func refreshDataInBackground() {
        Task {
            await MainActor.run { self.isRefreshing = true }

            do {
                // 1️⃣ Lấy danh sách bài hát đã có mix cũ
                let existingIds = Set(recentMixes.map { $0.id })

                // 2️⃣ Lấy danh sách bài đã nghe gần đây từ UserDefaults
                let recentIds = UserDefaults.standard.array(forKey: "recentlyPlayed") as? [String] ?? []

                // 3️⃣ Chỉ lấy những bài mới chưa có mix
                let newIds = recentIds.filter { !existingIds.contains($0) }

                if newIds.isEmpty {
                    print("⚡ Không có bài hát mới cần tạo mix.")
                    await MainActor.run { self.isRefreshing = false }
                    return
                }

                print("🔍 Cần tạo mix cho \(newIds.count) bài mới:", newIds)

                // 4️⃣ Gọi hàm fetchSimilarTracks cho từng bài mới
                var newMixes: [PersonalMix] = []
                for id in newIds {
                    do {
                        let mix = try await homeUseCase.fetchMixForSingleTrack(trackId: id)
                        newMixes.append(mix)
                    } catch {
                        print("⚠️ Bỏ qua lỗi khi tạo mix cho \(id):", error.localizedDescription)
                    }
                }

                // 5️⃣ Gộp mix mới vào danh sách cũ
                let updated = newMixes + recentMixes
                let filtered = updated.filter { !$0.similarTracks.isEmpty }

                await MainActor.run {
                    withAnimation(.easeOut(duration: 0.25)) {
                        self.recentMixes = filtered
                    }
                    self.saveCache()
                    self.isRefreshing = false
                }

                print("✅ Đã thêm \(newMixes.count) mix mới (tổng \(filtered.count)).")

            } catch {
                await MainActor.run {
                    self.isRefreshing = false
                    print("⚠️ Refresh thất bại:", error.localizedDescription)
                }
            }
        }
    }
}

// MARK: Cache
extension HomeViewModel {
    private var cacheURL: URL {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("home_cache.json")
    }
    
    func saveCache() {
        let cache = HomeCacheData(
            topAlbums: topAlbums,
            topTracks: topTracks,
            popularPlaylists: popularPlaylists,
            recentMixes: recentMixes,
            timestamp: Date()
        )
        
        if let data = try? JSONEncoder().encode(cache) {
            try? data.write(to: cacheURL)
            print("💾 Cache saved: \(cacheURL.lastPathComponent)")
        }
    }
    
    func loadCache() {
        guard let data = try? Data(contentsOf: cacheURL),
              let cache = try? JSONDecoder().decode(HomeCacheData.self, from: data) else {
            print("⚠️ No cache found.")
            return
        }
        
        // Check if the cache is too old (more than 24 hours)
        if Date().timeIntervalSince(cache.timestamp) > 24 * 3600 {
            print("⚠️ Cache expired, reloading...")
            return
        }
        
        self.topAlbums = cache.topAlbums
        self.topTracks = cache.topTracks
        self.popularPlaylists = cache.popularPlaylists
        self.recentMixes = cache.recentMixes
        print("✅ Loaded cache successfully.")
    }
}

struct HomeCacheData: Codable {
    let topAlbums: [JamendoAlbum]
    let topTracks: [JamendoTrack]
    let popularPlaylists: [JamendoPlaylistDetail]
    let recentMixes: [PersonalMix]
    let timestamp: Date
}
