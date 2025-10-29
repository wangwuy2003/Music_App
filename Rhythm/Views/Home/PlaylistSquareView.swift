//
//  PlaylistSquareView.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//
import SwiftUI
import SDWebImageSwiftUI

struct PlaylistSquareView: View {
    let playlist: HydratedPlaylist // Nhận model mới
    private let squareSize: CGFloat = 150

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            WebImage(url: URL(string: playlist.coverImage ?? ""))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width: squareSize, height: squareSize)
                .background(.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 5)
            
            Text(playlist.name)
                .font(.headline)
                .lineLimit(1)
                .foregroundStyle(.white)
            
            Text("Playlist")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .lineLimit(1)
        }
        .frame(width: squareSize)
    }
}
