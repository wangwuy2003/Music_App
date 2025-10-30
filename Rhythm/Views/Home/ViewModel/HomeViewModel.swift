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
    @Published var popularPlaylists: [JamendoPlaylistDetail] = []
    
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
    
    func openAlbumDetail(album: JamendoAlbum) {
        print("Tapped album: \(album.name)")
        router.showScreen(.push) { _ in
            PlaylistView(album: album)
        }
    }
    
    func openPlaylistDetail(playlist: JamendoPlaylistDetail) {
        print("Tapped playlist: \(playlist.name ?? "ID \(playlist.id)")")
        
        router.showScreen(.push) { _ in
            PlaylistTracksView(playlistId: playlist.id, playlistName: playlist.name ?? "Playlist")
        }
    }
}
