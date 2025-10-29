//
//  HomeView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

import SwiftUI
import SwiftfulRouting

struct HomeView: View {
    @Environment(\.router) var router
    @EnvironmentObject var homeVM: HomeViewModel // Giữ nguyên pattern của bạn
     
    var body: some View {
        ZStack {
            // 1. Nền
            LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            // 2. Nội dung chính
            mainContentView
             
            // 3. Lớp phủ Loading
            if homeVM.isLoading {
                ProgressView().tint(.white)
            }
             
            // 4. Lớp phủ Lỗi
            if let errorMessage = homeVM.errorMessage {
                errorView(errorMessage)
            }
        }
        .task {
            // Chỉ fetch data nếu list đang rỗng
            if homeVM.trendingSections.isEmpty {
                await homeVM.fetchData()
            }
        }
    }
     
    // Tách nội dung chính ra
    private var mainContentView: some View {
        ScrollView(showsIndicators: false) {
            titleView
                 
            VStack(spacing: 24) {
                // Hàng 'genre' (hardcoded) của bạn
                genreRow
                 
                // View mới cho các mục 'Trending' từ API
                trendingSectionsView
            }
        }
    }
    
    // View cho các mục 'Trending' từ API
    private var trendingSectionsView: some View {
        VStack(spacing: 20) {
            // Lặp qua [FeedModal]
            ForEach(homeVM.trendingSections) { feed in
                // Sử dụng view con 'FeedItemCard' mới
                FeedItemCard(feed: feed)
                    .onTapGesture {
                        homeVM.openItem(feed) // Thêm điều hướng
                    }
            }
        }
        .padding(.horizontal)
    }

    // View con cho từng thẻ 'Feed'
    struct FeedItemCard: View {
        let feed: FeedModal
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // Tải ảnh bìa
                AsyncImage(url: feed.coverImageURL) { image in
                    image.resizable()
                         .aspectRatio(16/9, contentMode: .fit)
                         .cornerRadius(8)
                } placeholder: {
                    // Ảnh chờ
                    Color.white.opacity(0.1)
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(8)
                }
                
                // Tiêu đề
                Text(feed.mainTitle)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                // Loại (Playlist, Album, ...)
                Text(feed.type.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
    }
     
    // View hiển thị khi có lỗi
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
                .foregroundStyle(.white) // Thêm màu
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top) // Thêm padding
    }
}

// Extension chứa 'genreRow' (không đổi)
extension HomeView {
    private var genreRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(.localized("Music genres"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white) // Thêm màu
                Spacer()
            }
            .padding(.horizontal)
             
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(MusicGenres.allCases) { genre in
                        Text(genre.name)
                            .font(.callout)
                            .bold()
                            .foregroundStyle(.white) // Thêm màu
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
