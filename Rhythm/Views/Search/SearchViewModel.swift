//
//  SearchViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 3/11/25.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasSearched: Bool = false
    
    @Published var tracks: [JamendoTrack] = []
    @Published var albums: [JamendoAlbum] = []
    @Published var artists: [JamendoArtist] = []
    @Published var playlists: [JamendoPlaylistMetadata] = []
    
    private let useCase = SearchUseCase()

    func searchAll() async {
        guard !searchText.isEmpty else { return }
        isLoading = true
        hasSearched = true
        errorMessage = nil

        do {
            async let tracksTask = useCase.searchTracks(name: searchText)
            async let albumsTask = useCase.searchAlbums(name: searchText)
            async let artistsTask = useCase.searchArtists(name: searchText)
            async let playlistsTask = useCase.searchPlaylists(name: searchText)
            
            let (tracksResult, albumsResult, artistsResult, playlistsResult) =
                try await (tracksTask, albumsTask, artistsTask, playlistsTask)
            
            tracks = tracksResult
            albums = albumsResult
            artists = artistsResult
            playlists = playlistsResult
            
        } catch {
            print("❌ SearchAll error:", error.localizedDescription)
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearResults() {
        tracks.removeAll()
        albums.removeAll()
        artists.removeAll()
        playlists.removeAll()
        hasSearched = false
    }
}
