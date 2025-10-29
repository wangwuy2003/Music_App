//
//  PlaylistTracksView.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import SwiftUI
import SwiftfulRouting
import SDWebImageSwiftUI

struct PlaylistTracksView: View {
    @Environment(\.router) var router
    @EnvironmentObject var playerVM: PlayerViewModel
    @StateObject private var vm = PlaylistTracksViewModel() // ✅ Dùng VM mới
    
    let playlist: JamendoPlaylist // ✅ Nhận JamendoPlaylist
    
    var body: some View {
        ZStack {
            // TODO: Thay bằng màu hex của bạn
            LinearGradient(gradient: Gradient(colors: [.indigo.opacity(0.8), .black]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            if vm.isLoading {
                ProgressView().tint(.white)
            } else if let msg = vm.errorMessage {
                Text(msg).foregroundColor(.red).padding()
            } else {
                List {
                    // Dùng Header mới (code ở dưới)
                    PlaylistHeaderView(playlist: playlist)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding(.bottom, 20)
                    
                    ForEach(vm.tracks) { track in
                        // Tái sử dụng TrackRowView (code ở file PlaylistView)
                        TrackRowView(track: track)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle(vm.playlist?.name ?? "Playlist")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchTracks(forPlaylist: playlist)
        }
    }
}

// Thêm Header View mới cho Playlist
struct PlaylistHeaderView: View {
    let playlist: JamendoPlaylist
    
    var body: some View {
        VStack(spacing: 16) {
            // Dùng ảnh vuông từ playlist.image
            WebImage(url: URL(string: playlist.image ?? ""))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: 200, height: 200)
                .background(.gray.opacity(0.3)) // Placeholder nếu ảnh nil
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.4), radius: 10)
            
            VStack(spacing: 4) {
                Text(playlist.name ?? "")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Text(playlist.userName ?? "Jamendo User")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
