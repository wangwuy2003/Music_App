//
//  PlaylistSquareView.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//
import SwiftUI
import SDWebImageSwiftUI

struct PlaylistSquareView: View {
    let playlist: JamendoPlaylistDetail
    private let squareSize: CGFloat = 150
    private let animationDuration: Double
    private let gradientColors: [Color]
    @State private var animateGradient = false
    @State private var pulseEffect = false

    init(playlist: JamendoPlaylistDetail) {
        self.playlist = playlist
        
        let gradients: [[Color]] = [
            [.purple, .blue],
            [.pink, .orange],
            [.green, .teal],
            [.indigo, .mint],
            [.red, .purple],
            [.cyan, .blue],
            [.orange, .yellow],
            [.pink, .indigo]
        ]
        
        let hash = abs(playlist.id.hashValue)
        let index = hash % gradients.count
        self.gradientColors = gradients[index]
        self.animationDuration = Double((hash % 30) + 25) / 10.0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack {
                if let url = URL(string: playlist.coverImageFromTrack ?? ""),
                   !(playlist.coverImageFromTrack ?? "").isEmpty {
                    WebImage(url: url)
                        .resizable()
                        .indicator(.activity)
                        .scaledToFill()
                } else {
                    LinearGradient(
                        colors: gradientColors.map {
                            $0.opacity(animateGradient ? 1.0 : 0.6)
                        },
                        startPoint: animateGradient ? .topLeading : .bottomTrailing,
                        endPoint: animateGradient ? .bottomTrailing : .topLeading
                    )
                    .animation(
                        .spring(duration: animationDuration).repeatForever(autoreverses: true),
                        value: animateGradient
                    )
                    .onAppear {
                        animateGradient = true
                    }
                    .overlay(
                        Image(systemName: "music.quarternote.3")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                            .scaleEffect(pulseEffect ? 1.1 : 0.95)
                            .shadow(color: .white.opacity(pulseEffect ? 0.6 : 0.1), radius: pulseEffect ? 12 : 2)
                            .animation(
                                .easeInOut(duration: animationDuration * 0.8)
                                    .repeatForever(autoreverses: true),
                                value: pulseEffect
                            )
                    )
                }

                VStack {
                    Spacer()
                    HStack {
                        Text(playlist.name ?? "Playlist")
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .shadow(radius: 2)
                        Spacer()
                    }
                    .padding(8)
                    .background(.black.opacity(0.35))
                }
            }
            .frame(width: squareSize, height: squareSize)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.4), radius: 5)

            Text(playlist.userName ?? "Jamendo")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .lineLimit(1)
        }
        .frame(width: squareSize)
    }
}
