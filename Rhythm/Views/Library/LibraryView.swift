//
//  LibraryView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import SwiftData

struct LibraryView: View {
    @Environment(\.router) var router
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var libraryVM: LibraryViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    
    @Query private var favourites: [FavouriteTrack]
    @Query private var playlists: [Playlist]
    @State private var isShowingAddSheet: Bool = false
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack {
                titleView
                buttonAddNewPlaylist
                
                if playlists.isEmpty && favourites.isEmpty {
                    emptyStateView
                } else {
                    playlistListView
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            AddPlaylistView()
                .presentationCornerRadius(25)
                .presentationDetents([.large])
        }
        .onAppear {
            libraryVM.attachModelContext(modelContext)
            libraryVM.ensureMyUploadsPlaylistExists()
        }
    }
}

// MARK: Subviews
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
        LinearGradient(
            gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var buttonAddNewPlaylist: some View {
        Button {
            isShowingAddSheet = true
        } label: {
            HStack(spacing: 20) {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .background(
                        Circle()
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.hexCBB7FF, .hex764ED9],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 40, height: 40)
                    )
                
                Text(.localized("Add a new playlist"))
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
            }
            .padding(.vertical, 10)
        }
    }
    
    private var playlistListView: some View {
        List {
            // --- Favourite Section ---
            FavouriteSection(tracks: favourites)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .onTapGesture {
                    router.showScreen(.push) { _ in
                        FavouritesView()
                            .environmentObject(libraryVM)
                    }
                }
            
            if let uploads = playlists.first(where: { $0.name == "My Uploads" }) {
                UploadSection(playlist: uploads)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        router.showScreen(.push) { _ in
                            UploadDetailView(playlist: uploads)
                                .environmentObject(libraryVM)
                                .environmentObject(playerVM)
                        }
                    }
            }
            
            // --- Playlist Section ---
            if !playlists.isEmpty {
                ForEach(playlists) { playlist in
                    if playlist.name != "My Uploads" {
                        PlaylistRow(
                            playlist: playlist,
                            onDelete: {
                                libraryVM.confirmDeletePlaylist(playlist)
                            },
                            onPlay: {
                                let tracks = playlist.tracks.map { $0.toJamendoTrack() }
                                playerVM.startPlayback(from: tracks, startingAt: 0)
                            },
                            onShuffle: {
                                let shuffled = playlist.tracks.shuffled().map { $0.toJamendoTrack() }
                                playerVM.startPlayback(from: shuffled, startingAt: 0)
                            },
                            onEdit: {
                                router.showScreen(.fullScreenCover) { _ in
                                    EditPlaylistView(playlist: playlist)
                                        .environmentObject(libraryVM)
                                        .environmentObject(playerVM)
                                }
                            }
                        )
                        .listRowInsets(EdgeInsets())
                        .listRowSpacing(10)
                        .listRowBackground(Color.clear)
                        .contextMenu {
                            Button {
                                let tracks = playlist.tracks.map { $0.toJamendoTrack() }
                                playerVM.startPlayback(from: tracks, startingAt: 0)
                            } label: {
                                Label(.localized("Play"), systemImage: "play")
                            }
                            
                            Button {
                                let shuffled = playlist.tracks.shuffled().map { $0.toJamendoTrack() }
                                playerVM.startPlayback(from: shuffled, startingAt: 0)
                            } label: {
                                Label(.localized("Shuffle"), systemImage: "shuffle")
                            }
                            
                            Button {
                                router.showScreen(.fullScreenCover) { _ in
                                    EditPlaylistView(playlist: playlist)
                                        .environmentObject(libraryVM)
                                        .environmentObject(playerVM)
                                }
                            } label: {
                                Label(.localized("Edit"), systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                libraryVM.confirmDeletePlaylist(playlist)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            router.showScreen(.push) { _ in
                                PlaylistDetailView(playlist: playlist)
                                    .environmentObject(playerVM)
                                    .environmentObject(libraryVM)
                            }
                        }

                    }
                }
            }
        }
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
        .padding(.horizontal)
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
