//
//  PlayerView.swift
//  Rhythm
//
//  Created by MacMini A6 on 28/10/25.
//

import SwiftUI
import LNPopupUI
import SDWebImageSwiftUI

struct PlayerView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    @Environment(\.popupBarPlacement) var popupBarPlacement
    @State private var volume: Float = 0.7
    @State private var isSliderEditing = false

    var body: some View {
        GeometryReader { geometry in
            let maxArtworkWidth = geometry.size.width - 40
            let currentArtworkWidth = maxArtworkWidth * (playerVM.audioPlayer.isPlaying ? 1.0 : 0.85)
            
            VStack(spacing: 28) {
                ZStack {
                    if let artwork = playerVM.artwork, let url = URL(string: artwork) {
                        WebImage(url: url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .shadow(color: .black.opacity(0.5), radius: 10)
//                            .padding([.leading, .trailing], 20)
//                            .padding([.top], geometry.size.height * 60 / 896.0)
                            .frame(width: currentArtworkWidth)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: playerVM.audioPlayer.isPlaying)
                            .popupTransitionTarget()
                    }
                }
                .frame(width: maxArtworkWidth, height: maxArtworkWidth)
                .padding([.top], geometry.size.height * 60 / 896.0)
                

                // MARK: Info
                VStack(spacing: 6) {
                    Text(playerVM.title)
                        .font(.title2).bold().lineLimit(1)
                    Text(playerVM.subtitle)
                        .font(.subheadline).foregroundColor(.gray).lineLimit(1)
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: Progress
                if playerVM.audioPlayer.duration > 0 {
                    VStack(spacing: 6) {
                        Slider(
                            value: $playerVM.audioPlayer.currentTime,
                            in: 0...playerVM.audioPlayer.duration,
                            onEditingChanged: { editing in
                                isSliderEditing = editing
                                if editing {
                                    playerVM.audioPlayer.pause()
                                } else {
                                    playerVM.audioPlayer.seek(to: playerVM.audioPlayer.currentTime)
                                    playerVM.audioPlayer.play()
                                }
                            }
                        )
                        .tint(.purple)

                        HStack {
                            Text(formatTime(playerVM.audioPlayer.currentTime))
                                .font(.caption).foregroundColor(.gray)
                            Spacer()
                            Text(formatTime(playerVM.audioPlayer.duration))
                                .font(.caption).foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                // MARK: Controls
                HStack {
                    Spacer()
                    Button {
                        print("Previous track")
                    } label: {
                        Image(systemName: "backward.fill")
                    }

                    Spacer()
                    Button {
                        playerVM.togglePlayback()
                    } label: {
                        Image(systemName: playerVM.audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 60))
                    }
                    .animation(.easeInOut(duration: 0.25), value: playerVM.audioPlayer.isPlaying)

                    Spacer()
                    Button {
                        print("Next track")
                    } label: {
                        Image(systemName: "forward.fill")
                    }
                    Spacer()
                }
                .font(.title2)
                .foregroundColor(.white)
                .padding(.horizontal, 24)

                // MARK: Volume
                HStack {
                    Image(systemName: "speaker.fill")
                    Slider(value: $volume).tint(.purple)
                    Image(systemName: "speaker.wave.2.fill")
                }
                .foregroundColor(.gray)
                .padding(.horizontal, 24)

                Spacer(minLength: geometry.size.height * 0.05)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(
                ZStack {
                    if let artwork = playerVM.artwork, let url = URL(string: artwork) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .blur(radius: 60)
                            .overlay(Color.black.opacity(0.55))
                    } else {
                        Color.black.opacity(0.6)
                    }
                }
                .ignoresSafeArea()
            )
        }

        // MARK: Popup Config
        .popupTitle(playerVM.title)
        .popupImage(playerVM.popupArtwork)
        .popupProgress(Float(
            playerVM.audioPlayer.duration > 0
            ? playerVM.audioPlayer.currentTime / playerVM.audioPlayer.duration
            : 0
        ))
        .popupBarItems {
            ToolbarItemGroup(placement: .popupBar) {
                Button {
                    playerVM.togglePlayback()
                } label: {
                    Image(systemName: playerVM.audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title3)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "forward.fill")
                }
            }
        }

        // ✅ Custom SwiftUI popup bar
        .popupBarCustomView {
            HStack {
                Button {
                    playerVM.togglePlayback()
                } label: {
                    Image(systemName: playerVM.audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title3)
                }
                .padding(.horizontal, 10)

                if popupBarPlacement != .inline {
                    Button {
                        print("Next")
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title3)
                    }
                    .padding(.horizontal, 10)
                }
            }
        }
    }

    // MARK: Helpers
    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite else { return "--:--" }
        let total = Int(seconds)
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}

#Preview {
    PlayerView()
}
