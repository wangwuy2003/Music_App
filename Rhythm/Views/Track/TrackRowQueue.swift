//
//  TrackRowQueue.swift
//  Rhythm
//
//  Created by Apple on 1/11/25.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftfulRouting
import SwiftData
import SwiftfulLoadingIndicators

struct TrackRowQueue: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    @Query private var playlists: [Playlist]
    
    let track: JamendoTrack
    
    var isCurrentPlaying: Bool {
        playerVM.currentTrack?.id == track.id
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                if let image = track.image {
                    WebImage(url: URL(string: image))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade)
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image("red_music_ic")
                }
                
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
                
                Text("Unknown")
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.gray)
                .padding(8)
            
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let total = seconds
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
