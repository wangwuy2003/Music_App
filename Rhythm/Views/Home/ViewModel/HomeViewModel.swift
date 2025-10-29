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
    let router: AnyRouter
    let homeUseCase = UseCaseProvider.makeHomeUseCase()
    
    @Published var topAlbums: [JamendoAlbum] = []
    @Published var topTracks: [JamendoTrack] = []
    @Published var popularPlaylists: [HydratedPlaylist] = []
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    init(router: AnyRouter) {
        self.router = router
    }
    
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
            
            async let hydratedPlaylistsTask = fetchHydratedPlaylists()
            
            topAlbums = try await albumsTask
            topTracks = try await tracksTask
            
            popularPlaylists = try await hydratedPlaylistsTask
            
            print("✅ Đã tải: \(topAlbums.count) albums, \(topTracks.count) tracks")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Yolo API Error:", error.localizedDescription)
        }
    }
    
    private func fetchHydratedPlaylists() async throws -> [HydratedPlaylist] {
        
        // 1. LẤY TÊN (1 CUỘC GỌI)
        // Lấy 20 playlist (trả về 20 object JamendoPlaylist)
        let playlists = try await homeUseCase.fetchPlaylists(byIDs: Constant.featuredPlaylistIDs)
        
        // 2. LẤY ẢNH BÌA (20 CUỘC GỌI SONG SONG)
        return try await withThrowingTaskGroup(of: HydratedPlaylist.self) { group in
            var hydratedList = [HydratedPlaylist]()
            
            for playlist in playlists {
                group.addTask {
                    // 3. Lấy 1 track đầu tiên cho playlist này
                    let tracks = try await self.homeUseCase.fetchTracks(
                        forPlaylistID: playlist.id, // Dùng ID của playlist
                        limit: 1
                    )
                    
                    // 4. Lấy ảnh của track đầu tiên đó
                    // (Phải đảm bảo JamendoTrack.image là String?)
                    let firstTrackImage = tracks.first?.image
                    
                    // ✅ THÊM 2 DÒNG PRINT NÀY
                    print("Playlist: \(playlist.id), \(playlist.name ?? "ID \(playlist.id)")")
                    print("  > Ảnh bìa (từ track 1): \(firstTrackImage ?? "==> BỊ TRỐNG (NIL)")")
                    // -----------------------------
                    
                    // 5. Tạo object cuối cùng
                    print("✅ Hydrated playlist: \(playlist.name)")
                    return HydratedPlaylist(
                        id: playlist.id, // Dùng ID của playlist
                        playlistId: playlist.id,
                        name: playlist.name ?? "Unknown", // Xử lý nil
                        coverImage: firstTrackImage
                    )
                }
            }
            
            // 6. Thu thập kết quả
            for try await hydratedItem in group {
                hydratedList.append(hydratedItem)
            }
            
            // 7. Sắp xếp lại theo thứ tự ID ban đầu
            let order = Constant.featuredPlaylistIDs
            let map = Dictionary(uniqueKeysWithValues: hydratedList.map { ($0.id, $0) })
            return order.compactMap { map[$0] }
        }
    }
    
    func openAlbumDetail(album: JamendoAlbum) {
        print("Tapped album: \(album.name)")
        router.showScreen(.push) { _ in
            PlaylistView(album: album)
        }
    }
    
    func openPlaylistDetail(playlist: JamendoPlaylist) {
        print("Tapped playlist: \(playlist.name)")
        router.showScreen(.push) { _ in
            PlaylistTracksView(playlist: playlist)
        }
    }
}
