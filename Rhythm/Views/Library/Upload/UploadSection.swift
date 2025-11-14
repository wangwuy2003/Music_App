//
//  UploadSection.swift
//  Rhythm
//
//  Created by MacMini A6 on 14/11/25.
//
import SwiftUI

struct UploadSection: View {
    var playlist: Playlist

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(colors: [.mint.opacity(0.6), .white],
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing))
                    .frame(width: 60, height: 60)

                Image("music_ic")
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("My Uploads")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("\(playlist.tracks.count) song\(playlist.tracks.count == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
