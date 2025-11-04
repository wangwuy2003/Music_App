//
//  ArtistDetailViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 4/11/25.
//


//
//  ArtistDetailViewModel.swift
//  Rhythm
//
//  Created by Apple on 3/11/25.
//

import SwiftUI

@MainActor
class ArtistDetailViewModel: ObservableObject {
    private let homeUseCase = UseCaseProvider.makeHomeUseCase()
    
    @Published var tracks: [JamendoTrack] = []
    @Published var artist: JamendoArtist?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func fetchTracks(forArtist artist: JamendoArtist) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        self.artist = artist
        
        defer { isLoading = false }
        
        do {
            let artistTracks = try await homeUseCase.fetchTracks(forArtistID: artist.id)
            self.tracks = artistTracks
            
            print("🎤 Đã tải \(artistTracks.count) bài hát cho artist \(artist.name) - \(artist)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Lỗi tải tracks cho artist:", error.localizedDescription)
        }
    }
}
