//
//  TrackRowView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftfulRouting
import SwiftData
import SwiftfulLoadingIndicators

struct TrackRowView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var libraryVM: LibraryViewModel
    
    @Query private var playlists: [Playlist]
    
    @State private var showAddToPlaylistSheet = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var isFavourite: Bool = false
    
    let track: JamendoTrack
    var playlist: Playlist? = nil
    
    var isCurrentPlaying: Bool {
        playerVM.currentTrack?.id == track.id
    }
    
    var isInFavouritesView: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                if let image = track.image {
                    WebImage(url: URL(string: image))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade)
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image("red_music_ic")
                }
                
                if isCurrentPlaying {
                    LoadingIndicator(animation: .fiveLinesWave, color: .white, size: .small)
                }
            }
            .frame(width: 50, height: 50)
            .clipped()
            

            VStack(alignment: .leading, spacing: 2) {
                Text(track.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                
                Text(track.artistName ?? "Unknown")
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundStyle(.white.opacity(0.7))
                
                if let reason = track.reason, !reason.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.white.opacity(0.6))
                        Text(reason)
                            .font(.caption2.italic())
                            .foregroundStyle(.white.opacity(0.6))
                            .lineLimit(2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
//            Text(formatDuration(track.duration ?? 00))
//                .font(.subheadline)
//                .foregroundStyle(.white.opacity(0.7))
            
            // MARK: Menu
            Menu {
                Button {
                    playerVM.addToQueueNext(track)
                    showQueueMessage("🎵 Added to play next")
                } label: {
                    Label(.localized("Play next"), systemImage: "text.line.first.and.arrowtriangle.forward")
                }
                
                Button {
                    playerVM.addToQueue(track)
                    showQueueMessage("🎶 Added to queue")	
                } label: {
                    Label(.localized("Add to queue"), systemImage: "text.line.last.and.arrowtriangle.forward")
                }
                
                Button {
                    showAddToPlaylistSheet = true
                } label: {
                    Label(.localized("Add to playlist"), systemImage: "text.badge.plus")
                }
                
                Divider()
                
                if isInFavouritesView {
                    Button(role: .destructive) {
                        libraryVM.confirmDeleteFavourite(track)
                    } label: {
                        Label(.localized("Delete"), systemImage: "trash")
                    }
                } else {
                    Button {
                        toggleFavourite()
                    } label: {
                        Label {
                            Text(isFavourite ? .localized("Remove from favourites") : .localized("Add to favourites"))
                        } icon: {
                            Image(systemName: isFavourite ? "star.fill" : "star")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(isFavourite ? .yellow : .gray)
                        }
                    }
                }
                
                Divider()
                
                if let playlist {
                    Button(role: .destructive) {
                        if let savedTrack = playlist.tracks.first(where: { $0.jamendoID == track.id }) {
                            libraryVM.confirmDeleteTrack(savedTrack, from: playlist)
                        }
                    } label: {
                        Label(.localized("Delete"), systemImage: "trash")
                    }
                }
                
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .padding(8)
                    .rotationEffect(Angle(degrees: -90))
            }
            .labelStyle(.titleAndIcon)
            
        }
        .contextMenu {
            Button {
                playerVM.addToQueueNext(track)
                showQueueMessage("🎵 Added to play next")
            } label: {
                Label(.localized("Play next"), systemImage: "text.line.first.and.arrowtriangle.forward")
            }
            
            Button {
                playerVM.addToQueue(track)
                showQueueMessage("🎶 Added to queue")
            } label: {
                Label(.localized("Add to queue"), systemImage: "text.line.last.and.arrowtriangle.forward")
            }
            
            Button {
                showAddToPlaylistSheet = true
            } label: {
                Label(.localized("Add to playlist"), systemImage: "text.badge.plus")
            }
            
            Divider()
            
            if isInFavouritesView {
                Button(role: .destructive) {
                    libraryVM.confirmDeleteFavourite(track)
                } label: {
                    Label(.localized("Delete"), systemImage: "trash")
                }
            } else {
                Button {
                    toggleFavourite()
                } label: {
                    Label {
                        Text(isFavourite ? .localized("Remove from favourites") : .localized("Add to favourites"))
                    } icon: {
                        Image(systemName: isFavourite ? "star.fill" : "star")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(isFavourite ? .yellow : .gray)
                    }
                }
            }
            
            Divider()
            
            if let playlist {
                Button(role: .destructive) {
                    if let savedTrack = playlist.tracks.first(where: { $0.jamendoID == track.id }) {
                        libraryVM.confirmDeleteTrack(savedTrack, from: playlist)
                    }
                } label: {
                    Label(.localized("Delete"), systemImage: "trash")
                }
            }
        }
//        .padding(.horizontal)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .sheet(isPresented: $showAddToPlaylistSheet) {
            AddToPlaylistSheet(track: track)
        }
        .overlay(
            VStack {
                if showToast {
                    Text(toastMessage)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.8))
                        .clipShape(Capsule())
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 50)
                }
            }
            , alignment: .bottom
        )
        .onAppear {
            checkIfFavourite()
            NotificationCenter.default.addObserver(forName: .favouritesDidChange, object: nil, queue: .main) { _ in
                checkIfFavourite()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .favouritesDidChange, object: nil)
        }
    }
}

// MARK: Functions
extension TrackRowView {
    private func formatDuration(_ seconds: Int) -> String {
        let total = seconds
        return String(format: "%d:%02d", total / 60, total % 60)
    }
    
    func showQueueMessage(_ message: String) {
        toastMessage = message
        withAnimation { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showToast = false }
        }
    }
    
    private func checkIfFavourite() {
        let descriptor = FetchDescriptor<FavouriteTrack>(
            predicate: #Predicate { $0.jamendoID == track.id }
        )
        if let results = try? modelContext.fetch(descriptor) {
            isFavourite = !results.isEmpty
        }
    }
    
    private func toggleFavourite() {
        let descriptor = FetchDescriptor<FavouriteTrack>(
            predicate: #Predicate { $0.jamendoID == track.id }
        )
        do {
            let results = try modelContext.fetch(descriptor)
            if let fav = results.first {
                modelContext.delete(fav)
                try modelContext.save()
                NotificationCenter.default.post(name: .favouritesDidChange, object: nil)
                isFavourite = false
                showQueueMessage("💔 Removed from favourites")
            } else {
                let newFav = FavouriteTrack(jamendoTrack: track)
                modelContext.insert(newFav)
                try modelContext.save()
                NotificationCenter.default.post(name: .favouritesDidChange, object: nil)
                isFavourite = true
                showQueueMessage("⭐ Added to favourites")
            }
        } catch {
            print("⚠️ Lỗi toggleFavourite:", error.localizedDescription)
        }
    }
}
