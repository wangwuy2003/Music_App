//
//  PlaylistViewModel.swift
//  Rhythm
//
//  Created by Apple on 4/10/25.
//
import SwiftUI
import Combine

@MainActor
class PlaylistViewModel: ObservableObject {
    let playlistUseCase = UseCaseProvider.makePlaylistUseCase()
    
    @Published var tracks: [TrackModel] = []
    @Published var playlist: PlaylistTracksModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()

    func fetchTracks(playlistId: Int) {
        isLoading = true
        errorMessage = nil
        
        playlistUseCase.fetchTracksFromPlaylist(playlistId: playlistId)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("API Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] playlist in
                self?.tracks = playlist.tracks
                self?.playlist = playlist
            }
            .store(in: &cancellables)
    }
    
}
