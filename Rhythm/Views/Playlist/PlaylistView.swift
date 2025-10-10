//
//  PlaylistView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

struct PlaylistView: View {
    @Environment(\.router) var router
    
    @EnvironmentObject var playerVM: PlayerViewModel
    @StateObject private var playlistVM = PlaylistViewModel()
    
    let tracks: [Track] = Track.sample
    let playlistId: Int
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]),
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            if playlistVM.isLoading {
                ProgressView().tint(.white)
            } else if let msg = playlistVM.errorMessage {
                Text(msg).foregroundColor(.red).padding()
            } else {
                List {
                    ForEach(playlistVM.tracks) { track in
                        TrackRowView(track: track)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .onAppear {
                                let isLast = (track.id == playlistVM.tracks.last?.id)
                                let canLoad = playlistVM.hasMore && !playlistVM.isLoadingMore
                                
                                if isLast && canLoad {
                                    Task { await playlistVM.loadMoreMissing(count: 5) }
                                }
                            }
                    }
                }
                .listStyle(.inset)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle(playlistVM.playlist?.title ?? "Unknown title")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await playlistVM.fetchTracks(playlistId: playlistId)
        }
    }
}

#Preview {
    PlaylistView(playlistId: 1231311)
}
