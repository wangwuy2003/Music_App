//
//  PlaylistTracksViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//
import Foundation

@MainActor
class PlaylistTracksViewModel: ObservableObject {
    private let homeUseCase = UseCaseProvider.makeHomeUseCase()
    
    @Published var tracks: [JamendoTrack] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func fetchTracks(forPlaylistID playlistID: String) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let playlistTracks = try await homeUseCase.fetchTracks(forPlaylistID: playlistID)
            self.tracks = playlistTracks
            
            print("🎧 Đã tải: \(playlistTracks.count) bài hát cho playlist \(playlistID)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Lỗi tải playlist tracks:", error.localizedDescription)
        }
    }
}
