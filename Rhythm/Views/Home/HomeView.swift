//
//  HomeView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

struct HomeView: View {
    @Environment(\.router) var router
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    titleView
                    
                    mixesSection
                    
                    if !homeVM.topAlbums.isEmpty {
                        HorizontalSectionView(
                            title: "Top Albums",
                            items: homeVM.topAlbums
                        ) { album in
                            AlbumSquareView(album: album)
                                .onTapGesture {
                                    router.showScreen(.push) { _ in
                                        PlaylistView(album: album)
                                            .environmentObject(playerVM) // ✅ Truyền playerVM vào
                                    }
                                }
                        }
                    }
                    
                    if !homeVM.popularPlaylists.isEmpty {
                        HorizontalSectionViewSplit(
                            title1: "🎵 Top Playlists",
                            title2: "🔥 More to Explore",
                            items: homeVM.popularPlaylists
                        ) { playlist in
                            PlaylistSquareView(playlist: playlist)
                                .onTapGesture {
                                    router.showScreen(.push) { _ in
                                        PlaylistTracksView(
                                            playlistId: playlist.id,
                                            playlistName: playlist.name ?? "Playlist"
                                        )
                                        .environmentObject(playerVM) // ✅ Truyền playerVM vào
                                    }
                                }
                        }
                    }
                    
                    if !homeVM.topTracks.isEmpty {
                        HorizontalSectionView(
                            title: "Top Tracks",
                            items: homeVM.topTracks
                        ) { track in
                            TrackSquareView(track: track)
                                .onTapGesture {
                                    playerVM.startPlayback(from: [track], startingAt: 0)
                                }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
            
            if homeVM.isLoading {
                ProgressView().tint(.white)
            }
            
            if let errorMessage = homeVM.errorMessage {
                errorView(errorMessage)
            }
        }
        //        .task {
        //            if homeVM.topAlbums.isEmpty && !homeVM.isLoading {
        //                await homeVM.fetchData()
        //                await homeVM.fetchSimilarMix()
        //            }
        //        }
        //        .onAppear {
        //            // Cập nhật router thực tế cho ViewModel
        //            if homeVM.router == nil {
        //                homeVM.router = router
        //            }
        //        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white)
            Text("Error")
                .font(.headline)
                .foregroundStyle(.white)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                Task {
                    await homeVM.fetchData()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.white.opacity(0.1))
            .clipShape(Capsule())
        }
        .padding()
        .background(.red.opacity(0.5))
        .cornerRadius(10)
        .padding()
    }
    
    private var titleView: some View {
        HStack {
            Text(.localized("Trending"))
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

extension HomeView {
    private var genreRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(.localized("Music genres"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(MusicGenres.allCases) { genre in
                        Text(genre.name)
                            .font(.callout)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(genre.gradient)
                            .clipShape(.rect(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Personalized Mixes Section
    @ViewBuilder
    private var mixesSection: some View {
       
        if !homeVM.recentMixes.filter({ !$0.similarTracks.isEmpty }).isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("🎧 Your Personalized Mixes")
                    .font(.title2.bold())
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(homeVM.recentMixes.filter { !$0.similarTracks.isEmpty }) { mix in
                            Button {
                                router.showScreen(.push) { _ in
                                    PlaylistTracksView(
                                        playlistId: mix.id,
                                        playlistName: "Mix based on \(mix.baseTrack.name)",
                                        customTracks: mix.similarTracks
                                    )
                                    .environmentObject(playerVM)
                                }
                            } label: {
                                VStack(spacing: 8) {
                                    // ảnh đại diện playlist (ảnh bài gốc)
                                    AsyncImage(url: URL(string: mix.baseTrack.image ?? mix.baseTrack.albumImage ?? "")) { phase in
                                        if let img = phase.image {
                                            img.resizable()
                                                .scaledToFill()
                                        } else if phase.error != nil {
                                            Color.gray.opacity(0.3)
                                                .overlay(Image(systemName: "music.note").foregroundColor(.white.opacity(0.7)))
                                        } else {
                                            ProgressView().tint(.white)
                                        }
                                    }
                                    .frame(width: 140, height: 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(color: .black.opacity(0.4), radius: 5)
                                    
                                    // tiêu đề
                                    Text("Mix based on\n\(mix.baseTrack.name)")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                        .frame(width: 140)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct HorizontalSectionView<Item: Identifiable & Hashable, Content: View>: View {
    let title: String
    let items: [Item]
    @ViewBuilder let content: (Item) -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2.bold())
                .padding(.horizontal)
                .foregroundStyle(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(items) { item in
                        content(item)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct HorizontalSectionViewSplit<Item: Identifiable & Hashable, Content: View>: View {
    let title1: String
    let title2: String
    let items: [Item]
    @ViewBuilder let content: (Item) -> Content
    
    private var firstHalf: [Item] {
        Array(items.prefix(items.count / 2))
    }
    
    private var secondHalf: [Item] {
        Array(items.suffix(items.count - items.count / 2))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title1)
                    .font(.title3.bold())
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(firstHalf) { item in
                            content(item)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title2)
                    .font(.title3.bold())
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(secondHalf) { item in
                            content(item)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
