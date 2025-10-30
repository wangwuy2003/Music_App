//
//  PlaylistViewModel.swift
//  Rhythm
//
//  Created by Apple on 4/10/25.
//
import SwiftUI

@MainActor
class PlaylistViewModel: ObservableObject {
    let homeUseCase = UseCaseProvider.makeHomeUseCase()
    
    @Published var tracks: [JamendoTrack] = []
    @Published var album: JamendoAlbum?
    @Published var errorMessage: String?
    
    @Published var isLoading: Bool = false
    
    func fetchTracks(forAlbum album: JamendoAlbum) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        self.album = album
        
        defer {
            isLoading = false
        }
        
        do {
            let albumTracks = try await homeUseCase.fetchTracks(forAlbumId: album.id)
            self.tracks = albumTracks
            
            print("🎧 Đã tải: \(albumTracks.count) bài hát cho album \(album.name)")
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Yolo API Error:", error.localizedDescription)
        }
    }
}
