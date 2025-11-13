//
//  PlaylistDetailView.swift
//  Rhythm
//
//  Created by Apple on 31/10/25.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftData
import SwiftfulRouting

struct PlaylistDetailView: View {
    @Environment(\.router) var router
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var playerVM: PlayerViewModel
    
    var playlist: Playlist
    
    var orderedTracks: [SavedTrack] {
        let tracks = playlist.tracks
        if var savedOrder = UserDefaults.standard.array(forKey: "playlist_order_\(playlist.id)") as? [String] {
            let newIDs = tracks.map { $0.jamendoID }
            for id in newIDs where !savedOrder.contains(id) {
                savedOrder.append(id)
            }
            UserDefaults.standard.set(savedOrder, forKey: "playlist_order_\(playlist.id)")
            return savedOrder.compactMap { id in
                tracks.first(where: { $0.jamendoID == id })
            }
        }
        return tracks
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.indigo.opacity(0.8), .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if playlist.tracks.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 60))
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Text("This playlist has no tracks yet.")
                        .foregroundStyle(.white.opacity(0.7))
                        .font(.headline)
                }
                .multilineTextAlignment(.center)
                .padding()
            } else {
                List {
                    // MARK: - Header View
                    PlaylistLocalHeaderView(
                        name: playlist.name,
                        description: playlist.playlistDescription,
                        imageData: playlist.imageData,
                        onPlay: {
                            let tracks = playlist.tracks.map { $0.toJamendoTrack() }
                            playerVM.startPlayback(from: tracks, startingAt: 0)
                        },
                        onShuffle: {
                            let shuffled = playlist.tracks.shuffled().map { $0.toJamendoTrack() }
                            playerVM.startPlayback(from: shuffled, startingAt: 0)
                        }
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    
                    // MARK: - Track list
                    ForEach(Array(orderedTracks.enumerated()), id: \.element.jamendoID) { index, track in
                        TrackRowView(track: track.toJamendoTrack(), playlist: playlist)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                let allTracks = playlist.tracks.map { $0.toJamendoTrack() }
                                playerVM.startPlayback(from: allTracks, startingAt: index)
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .enableSwipeBack()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

struct PlaylistLocalHeaderView: View {
    let name: String
    let description: String
    let imageData: Data?
    let onPlay: (() -> Void)?
    let onShuffle: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            // Playlist image
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.4), radius: 10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        Image(systemName: "music.note.list")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.7))
                    )
                    .shadow(color: .black.opacity(0.4), radius: 10)
            }
            
            // Playlist name
            Text(name)
                .font(.title2.bold())
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            // Play & Shuffle buttons
            HStack(spacing: 25) {
                Button {
                    print("▶️ Play \(name)")
                    onPlay?()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                        Text("Play")
                            .fontWeight(.semibold)
                    }
                    .frame(width: 120, height: 45)
                    .background(Color.pink)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
                
                Button {
                    print("🔀 Shuffle \(name)")
                    onShuffle?()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "shuffle")
                        Text("Random")
                            .fontWeight(.semibold)
                    }
                    .frame(width: 120, height: 45)
                    .background(Color.white.opacity(0.1))
                    .foregroundStyle(.pink)
                    .clipShape(Capsule())
                }
            }
            .padding(.top, 8)
            .buttonStyle(.borderless)
            
            Text(description)
                .font(.caption)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
