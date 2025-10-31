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
            let currentArtworkWidth = maxArtworkWidth * (playerVM.isPlaying ? 1.0 : 0.85)
            
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
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: playerVM.isPlaying)
                            .popupTransitionTarget()
                    }
                }
                .frame(width: maxArtworkWidth, height: maxArtworkWidth)
                .padding([.top], geometry.size.height * 60 / 896.0)
                

                // MARK: Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(playerVM.title)
                        .font(.title2).bold().lineLimit(1)
                    Text(playerVM.subtitle)
                        .font(.caption).foregroundColor(.secondary)
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: Progress
                VStack(spacing: 6) {
//                    if playerVM.duration > 0 {
                        Slider(
                            value: $playerVM.currentTime,
                            in: 0...playerVM.duration,
                            onEditingChanged: { editing in
                                isSliderEditing = editing
                                if editing {
                                    playerVM.pause()
                                } else {
                                    playerVM.seek(to: playerVM.currentTime)
                                    playerVM.play()
                                }
                            }
                        )
                        .tint(.purple)
//                    } else {
//                        // Khi duration = 0 (đang tải),
//                        // hiển thị một thanh tải để giữ không gian
//                        ProgressView()
//                            .progressViewStyle(.linear)
//                            .tint(.purple)
//                            .padding(.vertical, 10) // Giả lập chiều cao của Slider
//                    }

                    HStack {
                        Text(formatTime(playerVM.currentTime))
                            .font(.caption).foregroundColor(.gray)
                        Spacer()
                        Text(formatTime(playerVM.duration))
                            .font(.caption).foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 24)

                // MARK: Controls
                HStack {
                    Spacer()
                    Button {
                        print("Previous track")
                        playerVM.playPrevious()
                    } label: {
                        Image(systemName: "backward.fill")
                    }

                    Spacer()
                    Button {
                        playerVM.togglePlayback()
                    } label: {
                        Image(systemName: playerVM.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 60))
                    }
                    .animation(.easeInOut(duration: 0.25), value: playerVM.isPlaying)

                    Spacer()
                    Button {
                        playerVM.playNext()
                        print("Next track")
                    } label: {
                        Image(systemName: "forward.fill")
                    }
                    Spacer()
                }
                .font(.title2)
                .foregroundColor(.white)
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
            playerVM.duration > 0
            ? playerVM.currentTime / playerVM.duration
            : 0
        ))
        .popupBarItems {
            ToolbarItemGroup(placement: .popupBar) {
                Button {
                    playerVM.togglePlayback()
                } label: {
                    Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title3)
                }
                
                Button {
                    playerVM.playNext()
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
                    Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
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
