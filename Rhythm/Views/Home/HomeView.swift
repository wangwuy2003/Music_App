//
//  HomeView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    
    var body: some View {
        RouterView { _ in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        genreRow
                        
                        AlbumView()
                    }
                }
            }
            .navigationTitle(.localized("Trending"))
        }
    }
}

extension HomeView {
    private var genreRow: some View {
        VStack {
            
            HStack {
                Text(.localized("Music genres"))
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    
                    ForEach(MusicGenres.allCases) { genre in
                        Text(genre.name)
                            .font(.callout)
                            .bold()
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

#Preview {
    HomeView()
}
