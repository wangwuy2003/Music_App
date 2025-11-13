//
//  LibraryViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 31/10/25.
//

import Foundation
import SwiftfulRouting
import SwiftData
import SwiftUI

@MainActor
class LibraryViewModel: ObservableObject {
    let router: AnyRouter
    @Published var playlists: [Playlist] = []
    @Published var favourites: [FavouriteTrack] = []
    
    private var modelContext: ModelContext?
    
    init(router: AnyRouter) {
        self.router = router
    }
    
    func attachModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - Playlist Actions
    
    func deletePlaylist(_ playlist: Playlist) {
        guard let modelContext else { return }
        print("🗑️ Deleting playlist:", playlist.name)
        modelContext.delete(playlist)
    }
    
    func confirmDeletePlaylist(_ playlist: Playlist) {
        router.showAlert(
            .alert,
            title: "Delete \(playlist.name)?",
            subtitle: "This action cannot be undone."
        ) {
            Button("Cancel", role: .cancel) { }
            
            Button(.localized("Delete"), role: .destructive) { [weak self] in
                self?.deletePlaylist(playlist)
            }
        }
    }
    
    // MARK: - Delete track
    func confirmDeleteTrack(_ track: SavedTrack, from playlist: Playlist) {
        router.showAlert(
            .alert,
            title: "Remove “\(track.name)”?",
            subtitle: "This track will be deleted from \(playlist.name)."
        ) {
            Button("Cancel", role: .cancel) { }

            Button("Delete", role: .destructive) { [weak self] in
                self?.deleteTrack(track, from: playlist)
            }
        }
    }
    
    private func deleteTrack(_ track: SavedTrack, from playlist: Playlist) {
        guard let modelContext else { return }
        
        if let index = playlist.tracks.firstIndex(where: { $0.jamendoID == track.jamendoID }) {
            playlist.tracks.remove(at: index)
            try? modelContext.save()
            print("🗑️ Deleted track: \(track.name) from \(playlist.name)")
        }
    }
    
    
}

extension LibraryViewModel {
//    func isFavourite(_ track: JamendoTrack) -> Bool {
//        let descriptor = FetchDescriptor<FavouriteTrack>(
//            predicate: #Predicate { $0.jamendoID == track.id }
//        )
//        if let modelContext,
//           let results = try? modelContext.fetch(descriptor) {
//            return !results.isEmpty
//        }
//        return false
//    }
//    
//    func addToFavourites(_ track: JamendoTrack) {
//        guard let modelContext else { return }
//        
//        if isFavourite(track) { return }
//        
//        let favourite = FavouriteTrack(jamendoTrack: track)
//        modelContext.insert(favourite)
//        try? modelContext.save()
//        print("❤️ Added to favourites:", track.name)
//    }
    
    func deleteTrackFavourites(_ track: JamendoTrack) {
        guard let modelContext else { return }
                
        let descriptor = FetchDescriptor<FavouriteTrack>(
            predicate: #Predicate { $0.jamendoID == track.id }
        )
        if let results = try? modelContext.fetch(descriptor),
           let first = results.first {
            modelContext.delete(first)
            try? modelContext.save()
            print("💔 Removed from favourites:", track.name)
        }
    }
    
    // MARK: - Delete Favourite Track
    func confirmDeleteFavourite(_ track: JamendoTrack) {
        router.showAlert(
            .alert,
            title: "Delete “\(track.name)”?",
            subtitle: "This will remove it from your favourites."
        ) {
            Button("Cancel", role: .cancel) { }

            Button(.localized("Delete"), role: .destructive) { [weak self] in
                withAnimation(.easeInOut(duration: 0.3)) {
                    self?.deleteTrackFavourites(track)
                    NotificationCenter.default.post(name: .favouritesDidChange, object: nil)
                }
            }
        }
    }
}
