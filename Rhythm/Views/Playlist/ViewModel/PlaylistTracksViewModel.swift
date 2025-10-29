//
//  PlaylistTracksViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import SwiftUI

@MainActor
class PlaylistTracksViewModel: ObservableObject {
    let homeUseCase = UseCaseProvider.makeHomeUseCase() 
    
    @Published var tracks: [JamendoTrack] = []
    @Published var playlist: JamendoPlaylist?
    @Published var errorMessage: String?
    
    @Published var isLoading: Bool = false
    
    func fetchTracks(forPlaylist playlist: JamendoPlaylist) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        self.playlist = playlist
        
        defer {
            isLoading = false
        }
        
        do {
            let playlistTracks = try await homeUseCase.fetchTracks(forPlaylistID: playlist.id)
            self.tracks = playlistTracks
            
            print("🎧 Đã tải: \(playlistTracks.count) bài hát cho playlist \(playlist.name)")
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Yolo API Error:", error.localizedDescription)
        }
    }
}
