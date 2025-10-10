//
//  SearchView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var recentSearches: [String] = [
        "Ariana Grande",
        "Morgan Wallen",
        "Justin Bieber",
        "Drake",
        "Happy new year best music for eve night...",
        "Morgan Wallen"
    ]
    
    @State private var isSearching: Bool = false
    
    private var filtered: [String] {
        guard !searchText.isEmpty else { return recentSearches }
        return recentSearches.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    private var results: [SearchResult] {
        guard !searchText.isEmpty else { return [] }
        return [
            .song(title: "Vaina loca - osuna", subtitle: "Aura", duration: "3:04", stat: "3.5M"),
            .song(title: "Vaina loca - osuna", subtitle: "Aura", duration: "3:04", stat: "3.5M"),
            .playlist(title: "Playlist Name", subtitle: "Artis name", tracks: 15),
            .artist(title: "Ariana Grande", followers: "803K")
        ]
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.hex291F2A, .hex0F0E13], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Group {
                // searching
                if isSearching || !searchText.isEmpty {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(results.indices, id: \.self) { i in
                                ResultRow(result: results[i])
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                } else {
                    // default
                    VStack(spacing: 8) {
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
                            .contentShape(Rectangle())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                        }
                        .padding(.horizontal)
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
            }
        }
        .navigationTitle(.localized("Search"))
        .navigationBarTitleDisplayMode(.large)
        .modifier(SearchableCompatibility(searchText: $searchText, isSearching: $isSearching))
//        .searchable(text: $searchText, isPresented: $isSearching)
        .onAppear {
            DispatchQueue.main.async {
                if let searchBar = findSearchBar(),
                   let textField = searchBar.value(forKey: "searchField") as? UITextField {
                    
                    textField.backgroundColor = UIColor(Color.accentColor.opacity(0.15))
                    textField.textColor = .white
                    
                    textField.layer.borderColor = UIColor.accent.cgColor
                    textField.layer.borderWidth = 1.5
                    textField.layer.cornerRadius = 10
                    textField.layer.masksToBounds = true
                }
            }
        }
        .animation(.spring, value: isSearching)
        .animation(.spring, value: searchText)
    }
}

// MARK: subviews
extension SearchView {
    private var titleView: some View {
        HStack {
            Text(.localized("Search"))
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var clearAllView: some View {
        HStack {
            Text(.localized("Recent Search"))
                .font(.system(size: 18, weight: .bold))
            Spacer()
            
            Button {
                withAnimation {
                    recentSearches.removeAll()
                }
            } label: {
                Text(.localized("Clear All"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.accent)
            }
        }
        .padding()
    }
}

private struct SearchableCompatibility: ViewModifier {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .searchable(text: $searchText,
                            isPresented: $isSearching)
        } else {
            content
                .searchable(text: $searchText)
                .onChange(of: searchText) { newValue in
                    withAnimation { isSearching = !newValue.isEmpty }
                }
        }
    }
}
