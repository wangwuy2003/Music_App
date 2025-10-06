//
//  HomeView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import Combine

struct HomeView: View {
    @Environment(\.router) var router
    @State private var isExpanded = false
    @StateObject private var playerVM = PlayerViewModel()
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            if homeVM.isLoading {
                ProgressView().tint(.white)
            }
            
            ScrollView(showsIndicators: false) {
                titleView
                
                VStack(spacing: 24) {
                    genreRow
                    
                    AlbumView(sections: homeVM.trendingSections ?? [])
                }
            }
        }
        .toolbar(.hidden)
        .task {                          
            if homeVM.trendingSections == nil {
                homeVM.fetchData()
            }
        }
        .environmentObject(playerVM)
    }
    
    private var titleView: some View {
        HStack {
            Text(.localized("Trending"))
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding(.horizontal)
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
