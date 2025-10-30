//
//  PlaylistView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import SDWebImageSwiftUI // Cần import để hiển thị ảnh

struct PlaylistView: View {
    @Environment(\.router) var router
    @EnvironmentObject var playerVM: PlayerViewModel // Để phát nhạc
    @StateObject private var playlistVM = PlaylistViewModel() // Dùng VM mới ở trên
    
    // ✅ THAY ĐỔI: Nhận cả object JamendoAlbum
    let album: JamendoAlbum
    
    var body: some View {
        ZStack {
            // TODO: Thay bằng màu hex của bạn
            LinearGradient(gradient: Gradient(colors: [.indigo.opacity(0.8), .black]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            if playlistVM.isLoading {
                ProgressView().tint(.white)
            } else if let msg = playlistVM.errorMessage {
                // TODO: Tạo một ErrorView đẹp hơn
                Text(msg).foregroundColor(.red).padding()
            } else {
                // ✅ THAY ĐỔI: List đơn giản, không cần logic "load more"
                List {
                    // Thêm một header hiển thị ảnh và tên Album
                    AlbumHeaderView(album: album)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets()) // Xóa padding mặc định
                        .padding(.bottom, 20)
                    
                    ForEach(playlistVM.tracks) { track in
                        // Dùng TrackRowView mới (code ở dưới)
                        TrackRowView(track: track)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain) // Dùng .plain để header dính vào top
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle(playlistVM.album?.name ?? "Album")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // ✅ THAY ĐỔI: Gọi hàm fetch data mới
            await playlistVM.fetchTracks(forAlbum: album)
        }
    }
}

// --- CÁC VIEW PHỤ BẠN CẦN THÊM VÀO FILE NÀY ---

// ✅ VIEW MỚI: Dùng làm header cho List
struct AlbumHeaderView: View {
    let album: JamendoAlbum
    
    var body: some View {
        VStack(spacing: 16) {
            WebImage(url: URL(string: album.image))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.4), radius: 10)
            
            VStack(spacing: 4) {
                Text(album.name)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text(album.artistName)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let sampleAlbum = JamendoAlbum(
        id: "612188",
        name: "Out Of My Head",
        artistName: "Jon Worthy",
        image: "https://usercontent.jamendo.com?type=album&id=612188&width=300&trackid=2272627"
    )
    
    RouterView { _ in
        PlaylistView(album: sampleAlbum)
    }
    .environmentObject(PlayerViewModel())
}
