//
//  ArtistDetailView.swift
//  Rhythm
//
//  Created by Apple on 3/11/25.
//

import SwiftUI
import SwiftfulRouting
import SDWebImageSwiftUI

struct ArtistDetailView: View {
    @Environment(\.router) var router
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var playerVM: PlayerViewModel
    @StateObject private var vm = ArtistDetailViewModel()
    
    let artist: JamendoArtist
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    .purple.opacity(0.8),
                    colorScheme == .dark ? .black : .white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if vm.isLoading {
                ProgressView().tint(.white)
            } else if let error = vm.errorMessage {
                Text("⚠️ \(error)")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if !vm.tracks.isEmpty {
                List {
                    ArtistHeaderView(
                        artist: artist,
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
                Text("No tracks found for this artist.")
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .enableSwipeBack()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.dismissScreen()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                }
            }
        }
        .task {
            await vm.fetchTracks(forArtist: artist)
        }
    }
    
    private func playShuffled() {
        let shuffledTracks = vm.tracks.shuffled()
        playerVM.startPlayback(from: shuffledTracks, startingAt: 0)
    }
}

struct ArtistHeaderView: View {
    let artist: JamendoArtist
    let onPlay: (() -> Void)?
    let onShuffle: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            WebImage(url: URL(string: artist.image ?? ""))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 200, height: 200)
                .background(.gray.opacity(0.3))
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.4), radius: 10)
            
            VStack(spacing: 4) {
                Text(artist.name)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                if let website = artist.website {
                    Text(website)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
            
            HStack(spacing: 25) {
                Button {
                    print("▶️ Phát tất cả")
                    onPlay?()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                        Text(.localized("Play All"))
                            .fontWeight(.semibold)
                    }
                    .frame(width: 140, height: 45)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
                
                Button {
                    print("🔀 Xáo trộn")
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
