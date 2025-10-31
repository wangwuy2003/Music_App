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

struct TrackRowView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    let track: JamendoTrack
    @Query private var playlists: [Playlist]
    @State private var showAddToPlaylistSheet = false

    var body: some View {
        HStack(spacing: 12) {
            WebImage(url: URL(string: track.image ?? ""))
                .resizable()
                .indicator(.activity)
                .transition(.fade)
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(track.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                
                Text("Unknown")
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
//            Text(formatDuration(track.duration ?? 00))
//                .font(.subheadline)
//                .foregroundStyle(.white.opacity(0.7))
            
            Menu {
                Button {
                    
                } label: {
                    Label(.localized("Play next"), systemImage: "text.line.first.and.arrowtriangle.forward")
                }
                
                Button {
                    
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
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let total = seconds
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
