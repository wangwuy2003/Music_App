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
                // 1️⃣ Lấy danh sách các mix cũ (đã có)
                let existingIds = Set(recentMixes.map { $0.id })

                // 2️⃣ Lấy danh sách các bài hát đã nghe gần đây
                let recentIds = UserDefaults.standard.array(forKey: "recentlyPlayed") as? [String] ?? []

                // 3️⃣ Lọc ra các bài mới chưa có mix
                let newIds = recentIds.filter { !existingIds.contains($0) }

                if newIds.isEmpty {
                    print("⚡ Không có bài hát mới cần tạo mix.")
                    await MainActor.run { self.isRefreshing = false }
                    return
                }

                print("🚀 Bắt đầu tải mix cho \(newIds.count) bài mới...")

                // 4️⃣ Tạo nhóm Task chạy song song cho từng bài hát
                await withTaskGroup(of: PersonalMix?.self) { group in
                    for id in newIds {
                        group.addTask {
                            do {
                                let mix = try await self.homeUseCase.fetchMixForSingleTrack(trackId: id)
                                return mix
                            } catch {
                                print("⚠️ Lỗi khi tạo mix cho \(id):", error.localizedDescription)
                                return nil
                            }
                        }
                    }

                    // 5️⃣ Khi từng mix hoàn thành, cập nhật UI ngay
                    for await result in group {
                        if let mix = result, !mix.similarTracks.isEmpty {
                            await MainActor.run {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    self.recentMixes.insert(mix, at: 0) // thêm vào đầu danh sách
                                }
                                self.saveCache()
                            }
                            print("✅ Mix mới đã thêm cho \(mix.baseTrack.name)")
                        }
                    }
                }

                await MainActor.run {
                    self.isRefreshing = false
                    print("🎧 Hoàn tất cập nhật mixes — tổng cộng \(self.recentMixes.count) playlist.")
                }

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
