//
//  SearchView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

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
            LinearGradient(colors: [.hex291F2A, .hex0F0E13], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 8) {
                titleView
                
                SearchBarView(searchText: $searchVM.searchText)

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
