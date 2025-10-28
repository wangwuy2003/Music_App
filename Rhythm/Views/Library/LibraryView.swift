//
//  LibraryView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

struct LibraryView: View {
    @Environment(\.router) var router
    
//    @State private var playlists: [PlaylistItem] = [
//        .init(title: "Playlist name", songs: 10, thumb: "coverImage"),
//        .init(title: "Playlist name", songs: 0,  thumb: "coverImage"),
//        .init(title: "Playlist name", songs: 0,  thumb: "coverImage"),
//        .init(title: "Playlist name", songs: 0,  thumb: "coverImage"),
//        .init(title: "Playlist name", songs: 0,  thumb: "coverImage"),
//        .init(title: "Playlist name", songs: 0,  thumb: "coverImage"),
//        .init(title: "Playlist name", songs: 0,  thumb: "coverImage"),
//        .init(title: "Playlist name", songs: 0,  thumb: "coverImage"),
//        .init(title: "Playlist name", songs: 0,  thumb: "coverImage"),
//        .init(title: "Playlist name", songs: 0,  thumb: "coverImage"),
//    ]
    
    @State private var playlists: [PlaylistItem] = []
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack {
                titleView
                
                buttonAddNewPlaylist
                
                if !playlists.isEmpty {
                    playlistListView
                }
                
                Spacer()
            }
            
            if playlists.isEmpty {
                emptyStateView
            }
        }
//        .toolbar(content: {
//            ToolbarItem(placement: .topBarLeading) {
//                Text(.localized("Playlist"))
//                    .foregroundStyle(.white)
//                    .font(.largeTitle)
//                    .bold()
//            }
//        })
        .onAppear(perform: loadPlaylists)
    }
    
    private func loadPlaylists() {
        do {
            self.playlists = try StorageManager.shared.fetchAllPlaylists()
            print("✅ Successfully loaded \(playlists.count) playlists.")
        } catch {
            print("❌ Error loading playlists: \(error.localizedDescription)")
            self.playlists = []
        }
    }
    
    private func deletePlaylist(_ playlist: PlaylistItem) {
        do {
            try StorageManager.shared.deletetPlaylistDirectory(name: playlist.title)
            print("✅ Successfully deleted playlist: \(playlist.title)")
            loadPlaylists()
        } catch {
            print("❌ Error deleting playlist: \(error.localizedDescription)")
            router.showAlert(.alert,
                             title: .localized("Error"),
                             subtitle: .localized("Could not delete playlist: \(error.localizedDescription)"))
        }
    }
    
    private func showRenameModal(for playlist: PlaylistItem) {
        router.showModal(
            transition: .opacity,
            animation: .smooth(duration: 0.3),
            alignment: .center,
            backgroundColor: Color.black.opacity(0.5),
            backgroundEffect: BackgroundEffect(effect: UIBlurEffect(style: .systemMaterialDark), intensity: 0.1),
            dismissOnBackgroundTap: false,
            ignoreSafeArea: true,
            destination: {
                RenamePlaylistView(playlist: playlist, onPlaylistRenamed: self.loadPlaylists)
            }
        )
    }
    
    private func showDeleteConfirmation(for playlist: PlaylistItem) {
        router.showAlert(
            .alert,
            title: "Delete \(playlist.title)?",
            subtitle: "This action cannot be undone.") {
                Button(.localized("Cancel"), role: .cancel) {
                    router.dismissAlert()
                }
                
                Button(.localized("Delete"), role: .destructive) {
                    deletePlaylist(playlist)
                }
        }
    }
}

// MARK: - subviews
extension LibraryView {
    private var titleView: some View {
        HStack {
            Text(.localized("Playlist"))
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var backgroundView: some View {
        LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    
    private var buttonAddNewPlaylist: some View {
        Button {
            router.showModal(
                transition: .opacity,
                animation: .smooth(duration: 0.3),
                alignment: .center,
                backgroundColor: Color.black.opacity(0.5),
                backgroundEffect: BackgroundEffect(effect: UIBlurEffect(style: .systemMaterialDark), intensity: 0.1),
                dismissOnBackgroundTap: false,
                ignoreSafeArea: true,
                destination: {
                    AddPlaylistView(onPlaylistAdded: self.loadPlaylists)
                }
            )
        } label: {
            HStack(spacing: 20) {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .background(
                        Circle()
                            .foregroundStyle(LinearGradient(colors: [.hexCBB7FF, .hex764ED9], startPoint: .top, endPoint: .bottom))
                            .frame(width: 40, height: 40)
                    )
                
                Text(.localized("Add a new playlist"))
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
            }
            .padding(.vertical, 20)
        }
    }
    
    private var playlistListView: some View {
        List {
            ForEach(playlists) { playlist in
                PlaylistRow(
                    item: playlist,
                    onRename: {
                        showRenameModal(for: playlist)
                    },
                    onDelete: {
                        showDeleteConfirmation(for: playlist)
                    }
                )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView(
            .localized("No playlist"),
            systemImage: "play.square.stack.fill",
            description: Text(.localized("Add one to get started!"))
        )
        .transition(AnyTransition.opacity.animation(.easeInOut))
    }
}

#Preview {
    LibraryView()
}
