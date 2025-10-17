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
            LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                buttonAddNewPlaylist
                
                if playlists.isEmpty {
                    Text(.localized("No playlists yet. Add one to get started!"))
                        .foregroundStyle(.gray)
                        .padding(.top, 50)
                } else {
                    VStack(alignment: .leading) {
                        ForEach(playlists) { item in
                            PlaylistRow(item: item)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Text(.localized("Playlist"))
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .bold()
            }
        })
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
}

// MARK: - subviews
extension LibraryView {
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
}

#Preview {
    LibraryView()
}
