//
//  SearchView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import SwiftfulLoadingIndicators

enum SearchFilterType: String, CaseIterable, Identifiable {
    case all = "All"
    case tracks = "Tracks"
    case albums = "Albums"
    case artists = "Artists"
    case playlists = "Playlists"
    
    var id: String { rawValue }
}

struct SearchView: View {
    @Environment(\.router) var router
    @EnvironmentObject var playerVM: PlayerViewModel
    
    @StateObject private var searchVM = SearchViewModel()
    
    @State private var recentSearches: [String] = []
    @State private var isSearching: Bool = false
    @State private var selectedFilter: SearchFilterType = .all
    
    var body: some View {
            ZStack {
                backgroundGradient
                
                VStack(spacing: 8) {
                    titleView
                    searchBar
                    filterBar
                    contentArea
                }
                
                if searchVM.isLoading { loadingOverlay }
            }
            .onAppear {
                recentSearches = RecentSearchManager.shared.load()
            }
            .onChange(of: searchVM.searchText) { oldValue, newValue in
                if newValue.isEmpty {
                    searchVM.hasSearched = false
                }
            }
            .animation(.easeInOut(duration: 0.25), value: searchVM.isLoading)
        }

}

// MARK: - Subviews
extension SearchView {
    
    // MARK: Background
    private var backgroundGradient: some View {
        LinearGradient(colors: [.hex291F2A, .hex0F0E13], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    
    // MARK: Title
    private var titleView: some View {
        HStack {
            Text(.localized("Search"))
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding(.horizontal)
    }
    
    // MARK: SearchBar
    private var searchBar: some View {
        SearchBarView(searchText: $searchVM.searchText)
            .onSubmit {
                Task {
                    await handleSearchSubmit()
                }
            }
    }
    
    // MARK: FilterBar
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(SearchFilterType.allCases) { filter in
                    Button {
                        withAnimation(.easeInOut) {
                            if selectedFilter == filter {
                                selectedFilter = .all
                            } else {
                                selectedFilter = filter
                            }
                        }
                    } label: {
                        Text(filter.rawValue)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedFilter == filter ? Color.accentColor : Color.gray.opacity(0.3))
                            )
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 5)
    }
    
    // MARK: Main Content
    @ViewBuilder
    private var contentArea: some View {
        if !searchVM.hasSearched {
            recentSearchList
        } else {
            searchResultsView
        }
    }
    
    // MARK: Loading Overlay
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            
            LoadingIndicator(
                animation: .pulseOutline,
                color: .white,
                size: .large
            )
            .scaleEffect(1.2)
            .transition(.opacity)
        }
    }
}

// MARK: - Content Sections
extension SearchView {
    
    // MARK: Recent Search
    private var recentSearchList: some View {
        VStack(spacing: 0) {
            clearAllView
            
            List(recentSearches, id: \.self) { item in
                HStack {
                    Text(item)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "arrow.up.forward.app")
                        .foregroundColor(.gray)
                }
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    searchVM.searchText = item
                    Task { await handleSearchSubmit() }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.visible)
            }
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
        }
    }
    
    // MARK: Clear All Header
    private var clearAllView: some View {
        HStack {
            Text(.localized("Recent Search"))
                .font(.system(size: 18, weight: .bold))
            Spacer()
            
            Button {
                withAnimation {
                    recentSearches.removeAll()
                    RecentSearchManager.shared.clear()
                }
            } label: {
                Text(.localized("Clear All"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.accent)
            }
        }
        .padding()
    }
    
    // MARK: Search Results
    private var searchResultsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // MARK: Tracks
                if (selectedFilter == .all || selectedFilter == .tracks),
                   !searchVM.tracks.isEmpty {
                    SearchSectionView(
                        title: "🎵 Tracks",
                        items: searchVM.tracks.map {
                            SearchItem(id: $0.id,
                                       title: $0.name,
                                       subtitle: $0.artistName ?? "",
                                       imageURL: $0.image ?? $0.albumImage)
                        },
                        onTap: { id in
                            if let track = searchVM.tracks.first(where: { $0.id == id }) {
                                playerVM.startPlayback(from: searchVM.tracks, startingAt: searchVM.tracks.firstIndex(where: { $0.id == id }) ?? 0)
                                RecentSearchManager.shared.add(track.name)
                                recentSearches = RecentSearchManager.shared.load()
                            }
                        },
                        type: .track
                    )
                }
                
                // MARK: Albums
                if (selectedFilter == .all || selectedFilter == .albums),
                   !searchVM.albums.isEmpty {
                    SearchSectionView(
                        title: "💿 Albums",
                        items: searchVM.albums.map {
                            SearchItem(id: $0.id,
                                       title: $0.name,
                                       subtitle: $0.artistName,
                                       imageURL: $0.image)
                        },
                        onTap: { id in
                            if let album = searchVM.albums.first(where: { $0.id == id }) {
                                router.showScreen(.push) { _ in
                                    PlaylistView(album: album)
                                }
                                RecentSearchManager.shared.add(album.name)
                                recentSearches = RecentSearchManager.shared.load()
                            }
                        },
                        type: .album
                    )
                }
                
                // MARK: Artists
                if (selectedFilter == .all || selectedFilter == .artists),
                   !searchVM.artists.isEmpty {
                    SearchSectionView(
                        title: "👩‍🎤 Artists",
                        items: searchVM.artists.map {
                            SearchItem(id: $0.id,
                                       title: $0.name,
                                       subtitle: $0.website ?? "",
                                       imageURL: $0.image)
                        },
                        onTap: { id in
                            if let artist = searchVM.artists.first(where: { $0.id == id }) {
                                router.showScreen(.push) { _ in
                                    ArtistDetailView(artist: artist)
                                }
                                RecentSearchManager.shared.add(artist.name)
                                recentSearches = RecentSearchManager.shared.load()
                            }
                        },
                        type: .artist
                    )
                }
                
                // MARK: Playlists
                if (selectedFilter == .all || selectedFilter == .playlists),
                   !searchVM.playlists.isEmpty {
                    SearchSectionView(
                        title: "🎧 Playlists",
                        items: searchVM.playlists.map {
                            SearchItem(id: $0.id,
                                       title: $0.name,
                                       subtitle: $0.userName ?? "",
                                       imageURL: $0.image)
                        },
                        onTap: { id in
                            if let playlist = searchVM.playlists.first(where: { $0.id == id }) {
                                router.showScreen(.push) { _ in
                                    PlaylistTracksView(
                                        playlistId: playlist.id,
                                        playlistName: playlist.name
                                    )
                                }
                                RecentSearchManager.shared.add(playlist.name)
                                recentSearches = RecentSearchManager.shared.load()
                            }
                        },
                        type: .playlist
                    )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }

}

// MARK: - Actions
extension SearchView {
    private func handleSearchSubmit() async {
        await searchVM.searchAll()
        
        if !searchVM.searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            RecentSearchManager.shared.add(searchVM.searchText)
            recentSearches = RecentSearchManager.shared.load()
        }
    }
}
