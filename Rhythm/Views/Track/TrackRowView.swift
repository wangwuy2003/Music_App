//
//  TrackRowView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftfulRouting
import SwiftData
import SwiftfulLoadingIndicators

struct TrackRowView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    @Query private var playlists: [Playlist]
    @State private var showAddToPlaylistSheet = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    
    let track: JamendoTrack
    
    var isCurrentPlaying: Bool {
        playerVM.currentTrack?.id == track.id
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                WebImage(url: URL(string: track.image ?? ""))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade)
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                if isCurrentPlaying {
                    LoadingIndicator(animation: .fiveLinesWave, color: .white, size: .small)
                }
            }
            .frame(width: 50, height: 50)
            .clipped()
            

            VStack(alignment: .leading, spacing: 2) {
                Text(track.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                
                Text(track.artistName ?? "Unknown")
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundStyle(.white.opacity(0.7))
                
                if let reason = track.reason, !reason.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.white.opacity(0.6))
                        Text(reason)
                            .font(.caption2.italic())
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
//            Text(formatDuration(track.duration ?? 00))
//                .font(.subheadline)
//                .foregroundStyle(.white.opacity(0.7))
            
            Menu {
                Button {
                    playerVM.addToQueueNext(track)
                    showQueueMessage("🎵 Added to play next")
                } label: {
                    Label(.localized("Play next"), systemImage: "text.line.first.and.arrowtriangle.forward")
                }
                
                Button {
                    playerVM.addToQueue(track)
                    showQueueMessage("🎶 Added to queue")
                } label: {
                    Label(.localized("Add to queue"), systemImage: "text.line.last.and.arrowtriangle.forward")
                }
                
                Button {
                    showAddToPlaylistSheet = true
                } label: {
                    Label(.localized("Add to playlist"), systemImage: "text.badge.plus")
                }
                
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .padding(8)
                    .rotationEffect(Angle(degrees: -90))
            }
            .labelStyle(.titleAndIcon)
            
        }
//        .padding(.horizontal)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .sheet(isPresented: $showAddToPlaylistSheet) {
            AddToPlaylistSheet(track: track)
        }
        .overlay(
            VStack {
                if showToast {
                    Text(toastMessage)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.8))
                        .clipShape(Capsule())
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 50)
                }
            }
            , alignment: .bottom
        )
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let total = seconds
        return String(format: "%d:%02d", total / 60, total % 60)
    }
    
    func showQueueMessage(_ message: String) {
        toastMessage = message
        withAnimation { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showToast = false }
        }
    }
}
