//
//  TrackSquareView.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import SwiftUI
import SDWebImageSwiftUI

struct TrackSquareView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    let track: JamendoTrack
    private let squareSize: CGFloat = 150

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            WebImage(url: URL(string: track.image ?? ""))
                .resizable()
                .indicator(.activity)
                .transition(.fade)
                .scaledToFill()
                .frame(width: squareSize, height: squareSize)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 5)
                .overlay(
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(radius: 5)
                        .padding(8)
                    , alignment: .bottomTrailing
                )
            
            Text(track.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(track.artistName ?? "Unknown Artist")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: squareSize)
//        .onTapGesture {
//            playerVM.play(track: track)
//        }
    }
}
