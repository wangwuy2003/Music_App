//
//  PlaylistViewModel.swift
//  Rhythm
//
//  Created by Apple on 4/10/25.
//
import SwiftUI

@MainActor
class PlaylistViewModel: ObservableObject {
    // Usecases
    let playlistUseCase = UseCaseProvider.makePlaylistUseCase()
    let trackUseCase = UseCaseProvider.makeTrackUseCase()
    
    // Data display
    @Published var tracks: [TrackModel] = []
    @Published var playlist: PlaylistTracksModel?
    @Published var errorMessage: String?
    
    // Status
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var hasMore: Bool = false
    
    private var pendingIDs: [Int] = []
    private var originalOrders: [Int] = []
    
    func fetchTracks(playlistId: Int) async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        
        do {
            let playlist = try await playlistUseCase.fetchTracksFromPlaylist(playlistId: playlistId)
            self.playlist = playlist
            
            // save order id follow original playlist
            self.originalOrders = playlist.tracks.map { $0.id }
            
            // divide track: full info & pending
            let (full, missing) = splitFullAndMissing(playlist.tracks)
            self.tracks = order(full)
            self.pendingIDs = missing.map { $0.id }
            self.hasMore = !self.pendingIDs.isEmpty
            
            if hasMore {
                await loadMoreMissing(count: 5)
            }
            
            print("🎧 Yolo Playlist loaded: \(playlist.title), \(playlist.tracks.count) tracks")
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Yolo API Error:", error.localizedDescription)
        }
    }
    
    func loadMoreMissing(count: Int) async {
        guard !isLoadingMore,
              !pendingIDs.isEmpty else {
            return
        }
        
        isLoadingMore = true
        defer {
            isLoadingMore = false
        }
        
        let take = Array(pendingIDs.prefix(count))
        pendingIDs.removeFirst(min(count, pendingIDs.count))
        
        do {
            let hydrated: [TrackModel] = try await withThrowingTaskGroup(of: TrackModel.self) { group in
                for id in take {
                    group.addTask { [trackUseCase] in
                        try await trackUseCase.fechTrack(trackId: id)
                    }
                }
                return try await group.reduce(into: []) { $0.append($1) }
            }
            
            let merged = mergeAndOrder(current: tracks, incoming: hydrated)
            self.tracks = merged
            
            self.hasMore = !pendingIDs.isEmpty
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Yolo Hydrate error:", error.localizedDescription)
        }
    }
}

extension PlaylistViewModel {
    private func isFull(_ track: TrackModel) -> Bool {
        (track.title != nil) && (track.duration != nil)
    }
    
    private func splitFullAndMissing(_ list: [TrackModel]) -> (full: [TrackModel], missing: [TrackModel]) {
        let full = list.filter(isFull)
        let missing = list.filter { !isFull($0) }
        return (full, missing)
    }
    
    private func order(_ list: [TrackModel]) -> [TrackModel] {
        let dict = Dictionary(uniqueKeysWithValues: list.map { ($0.id, $0) })
        
        return originalOrders.compactMap { dict[$0] }
    }
    
    private func mergeAndOrder(current: [TrackModel], incoming: [TrackModel]) -> [TrackModel] {
        var dict = Dictionary(uniqueKeysWithValues: current.map { ($0.id, $0) })
        
        for t in incoming {
            dict[t.id] = t
        }
        
        return originalOrders.compactMap { dict[$0] }
    }
}
