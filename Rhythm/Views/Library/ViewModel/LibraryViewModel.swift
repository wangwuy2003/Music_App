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
    
    private var modelContext: ModelContext?
    
    init(router: AnyRouter) {
        self.router = router
    }
    
    // Gắn modelContext từ View
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
    
    func openPlaylistDetail(_ playlist: Playlist) {
        print("🎵 Opening playlist detail for:", playlist.name)
        router.showScreen(.push) { _ in
            PlaylistDetailView(playlist: playlist)
        }
    }
}
