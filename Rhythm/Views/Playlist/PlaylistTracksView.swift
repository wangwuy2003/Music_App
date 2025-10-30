//
//  PlaylistTracksView.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import SwiftUI
import SwiftfulRouting
import SDWebImageSwiftUI

struct PlaylistTracksView: View {
    @Environment(\.router) var router
    @EnvironmentObject var playerVM: PlayerViewModel
    @StateObject private var vm = PlaylistTracksViewModel()
    
    let playlistId: String
    let playlistName: String
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.indigo.opacity(0.8), .black]),
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            if vm.isLoading {
                ProgressView()
                    .tint(.white)
            } else if let error = vm.errorMessage {
                Text("⚠️ \(error)")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if !vm.tracks.isEmpty {
                List {
                    PlaylistHeaderView(
                        name: playlistName,
                        coverURL: vm.tracks.first?.albumImage,
                        onPlay: {
                            playerVM.startPlayback(from: vm.tracks, startingAt: 0)
                        },
                        onShuffle: {
                            playShuffled()
                        }
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding(.bottom, 20)
                    
                    ForEach(Array(vm.tracks.enumerated()), id: \.element.id) { index, track in
                        TrackRowView(track: track)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                playerVM.startPlayback(from: vm.tracks, startingAt: index)
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } else {
                Text("No tracks found in this playlist.")
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchTracks(forPlaylistID: playlistId)
        }
    }
    
    private func playShuffled() {
        let shuffledTracks = vm.tracks.shuffled()
        playerVM.startPlayback(from: shuffledTracks, startingAt: 0)
    }
}

struct PlaylistHeaderView: View {
    let name: String
    let coverURL: String?
    
    let onPlay: (() -> Void)?
    let onShuffle: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            WebImage(url: URL(string: coverURL ?? ""))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 200, height: 200)
                .background(.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.4), radius: 10)
            
            Text(name)
                .font(.title2.bold())
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
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
                    .frame(width: 120, height: 45)
                    .background(Color.pink)
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
                    .frame(width: 120, height: 45)
                    .background(Color.white.opacity(0.1))
                    .foregroundStyle(.pink)
                    .clipShape(Capsule())
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
