//
//  PlaylistView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import SDWebImageSwiftUI

struct PlaylistView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.router) var router
    @EnvironmentObject var playerVM: PlayerViewModel 
    @StateObject private var playlistVM = PlaylistViewModel()
    @State private var gradient = LinearGradient.randomDark()
    
    let album: JamendoAlbum
    
    var body: some View {
        ZStack {
            gradient
                .ignoresSafeArea()
            
            if playlistVM.isLoading {
                ProgressView().tint(.white)
            } else if let msg = playlistVM.errorMessage {
                Text(msg).foregroundColor(.red).padding()
            } else {
                List {
                    AlbumHeaderView(
                        album: album,
                        onPlay: {
                            playerVM.startPlayback(from: playlistVM.tracks, startingAt: 0)
                        },
                        onShuffle: {
                            playShuffled()
                        }
                    )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding(.bottom, 20)
                    
                    ForEach(playlistVM.tracks) { track in
                        TrackRowView(track: track)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .enableSwipeBack()
        .navigationBarBackButtonHidden()
        .navigationTitle(playlistVM.album?.name ?? "Album")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await playlistVM.fetchTracks(forAlbum: album)
        }
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
    
    private func playShuffled() {
        let shuffledTracks = playlistVM.tracks.shuffled()
        playerVM.startPlayback(from: shuffledTracks, startingAt: 0)
    }
}

struct AlbumHeaderView: View {
    let album: JamendoAlbum
    
    let onPlay: (() -> Void)?
    let onShuffle: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            WebImage(url: URL(string: album.image))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.4), radius: 10)
            
            VStack(spacing: 4) {
                Text(album.name)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text(album.artistName)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            HStack(spacing: 25) {
                Button {
                    print("▶️ Phát playlist")
                    onPlay?()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                        Text(.localized("Play"))
                            .fontWeight(.semibold)
                    }
                    .frame(width: 140, height: 45)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
                
                Button {
                    print("🔀 Xáo trộn playlist")
                    onShuffle?()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "shuffle")
                        Text(.localized("Random"))
                            .fontWeight(.semibold)
                    }
                    .frame(width: 140, height: 45)
                    .background(Color.white.opacity(0.1))
                    .foregroundStyle(.accent)
                    .clipShape(Capsule())
                }
            }
            .padding(.top, 8)
            .buttonStyle(.borderless)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let sampleAlbum = JamendoAlbum(
        id: "612188",
        name: "Out Of My Head",
        artistName: "Jon Worthy",
        image: "https://usercontent.jamendo.com?type=album&id=612188&width=300&trackid=2272627"
    )
    
    RouterView { _ in
        PlaylistView(album: sampleAlbum)
    }
    .environmentObject(PlayerViewModel())
}
