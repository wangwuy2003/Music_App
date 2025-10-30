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
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    titleView
                    
                    if !homeVM.topAlbums.isEmpty {
                        HorizontalSectionView(
                            title: "Top Albums",
                            items: homeVM.topAlbums
                        ) { album in
                            AlbumSquareView(album: album)
                                .onTapGesture {
                                    homeVM.openAlbumDetail(album: album)
                                }
                        }
                    }
                    
                    if !homeVM.topTracks.isEmpty {
                        HorizontalSectionView(
                            title: "Top Tracks",
                            items: homeVM.topTracks
                        ) { track in
                            TrackSquareView(track: track)
                        }
                    }
                    
                    if !homeVM.popularPlaylists.isEmpty {
                        HorizontalSectionView(
                            title: "Popular Playlists",
                            items: homeVM.popularPlaylists
                        ) { playlist in
                            PlaylistSquareView(playlist: playlist)
                                .onTapGesture {
                                    homeVM.openPlaylistDetail(playlist: playlist)
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
        .task {
            if homeVM.topAlbums.isEmpty && !homeVM.isLoading {
                await homeVM.fetchData()
            }
        }
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
