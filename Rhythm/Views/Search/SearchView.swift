//
//  SearchView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import SwiftfulLoadingIndicators

struct SearchView: View {
    @StateObject private var searchVM = SearchViewModel()
    @State private var recentSearches: [String] = [
        "Ariana Grande",
        "Morgan Wallen",
        "Justin Bieber",
        "Drake",
        "Happy new year best music for eve night...",
        "Morgan Wallen"
    ]
    
    @State private var isSearching: Bool = false
    
    var body: some View {
            ZStack {
                backgroundGradient
                
                VStack(spacing: 8) {
                    titleView
                    searchBar
                    contentArea
                }
                
                if searchVM.isLoading { loadingOverlay }
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
        VStack {
            clearAllView
            
            List(recentSearches, id: \.self) { item in
                HStack {
                    Text(item)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    searchVM.searchText = item
                    Task { await searchVM.searchAll() }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .padding(.horizontal)
            .listStyle(.plain)
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
                withAnimation { recentSearches.removeAll() }
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
                if !searchVM.tracks.isEmpty {
                    SearchSectionView(
                        title: "🎵 Tracks",
                        items: searchVM.tracks.map {
                            SearchItem(id: $0.id,
                                       title: $0.name,
                                       subtitle: $0.artistName ?? "",
                                       imageURL: $0.image ?? $0.albumImage)
                        },
                        onTap: { id in print("Play track \(id)") }
                    )
                }
                
                if !searchVM.albums.isEmpty {
                    SearchSectionView(
                        title: "💿 Albums",
                        items: searchVM.albums.map {
                            SearchItem(id: $0.id,
                                       title: $0.name,
                                       subtitle: $0.artistName,
                                       imageURL: $0.image)
                        },
                        onTap: { id in print("Open Album \(id)") }
                    )
                }
                
                if !searchVM.artists.isEmpty {
                    SearchSectionView(
                        title: "👩‍🎤 Artists",
                        items: searchVM.artists.map {
                            SearchItem(id: $0.id,
                                       title: $0.name,
                                       subtitle: $0.website ?? "",
                                       imageURL: $0.image)
                        },
                        onTap: { id in print("Open Artist \(id)") }
                    )
                }
                
                if !searchVM.playlists.isEmpty {
                    SearchSectionView(
                        title: "🎧 Playlists",
                        items: searchVM.playlists.map {
                            SearchItem(id: $0.id,
                                       title: $0.name,
                                       subtitle: $0.userName ?? "",
                                       imageURL: $0.image)
                        },
                        onTap: { id in print("Open Playlist \(id)") }
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
        
        if !recentSearches.contains(searchVM.searchText),
           !searchVM.searchText.isEmpty {
            recentSearches.insert(searchVM.searchText, at: 0)
        }
    }
}
