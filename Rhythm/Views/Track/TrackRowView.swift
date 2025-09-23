//
//  TrackRowView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI

struct TrackRowView: View {
    let track: Track
    
    var body: some View {
        HStack(spacing: 12) {
            Image(track.cover)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(track.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(track.artist)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text(track.duration)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 6) {
                    Image(systemName: "play.fill")
                        .font(.caption2)
                    
                    Text(track.playCount)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(minWidth: 72, alignment: .trailing)
        }
    }
}

#Preview {
    TrackRowView(track: Track(title: "Vaina loca",
                              artist: "Aura",
                              duration: "3:04",
                              playCount: "3.5M",
                              cover: "coverImage"))
}
