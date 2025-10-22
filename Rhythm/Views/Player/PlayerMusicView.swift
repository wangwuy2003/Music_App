//
//  MusicView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import LoremIpsum
import AVFoundation
import AVFAudio

struct PlayerMusicView: View {
    var song: TrackModel {
        mediaPlayerState.currentTrack ?? TrackModel.mock
    }
    
    @EnvironmentObject var mediaPlayerState: MediaPlayerState
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var isSliderEditing = false
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            if let song = mediaPlayerState.currentTrack {
                if let artworkUrl = song.artworkUrl {
                    CachedAsyncImage(url: URL(string: artworkUrl))
                        .blur(radius: 30, opaque: true)
                        .overlay(.background.opacity(0.5))
                }
                
                Group {
                    if mediaPlayerState.isMediaPlayerExpanded {
                        GeometryReader { geometry in
                            VStack(spacing: 20) {
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(width: 50, height: 5)
                                    .foregroundColor(Color.gray.opacity(0.7))
                                    .padding(.top, 10)
                                    .padding(.bottom, 150)
                                    .offset(y: dragOffset) // Animate button with the drag
                                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: dragOffset)
                                
                                Spacer()
                                
                                VStack(spacing: 10) {
                                    CachedAsyncImage(url: URL(string: song.artworkUrl ?? ""))
                                        .frame(width: 250, height: 250)
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .transition(.scale)
                                }
                                
                                // Song Info
                                VStack {
                                    Text(song.title ?? "")
                                        .font(.title3)
                                        .bold()
                                        .transition(.opacity) // Fade-in for song title and info
                                    
                                    Text(song.genre ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                // Progress Slider
                                if audioPlayer.duration > 0 {
                                    Slider(value: $audioPlayer.currentTime, in: 0 ... audioPlayer.duration, step: 1) { editing in
                                        isSliderEditing = editing
                                        if editing {
                                            audioPlayer.pause()
                                        } else {
                                            audioPlayer.seek(to: audioPlayer.currentTime)
                                            audioPlayer.play()
                                        }
                                    }
                                    .tint(.purple)
                                    .blendMode(.difference)
                                    .padding(.horizontal)
                                    
                                    HStack {
                                        Text(timeString(for: audioPlayer.currentTime))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(timeString(for: audioPlayer.duration))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal)
                                } else {
                                    Text("Loading...")
                                        .foregroundColor(.gray)
                                }
                                
                                // Playback Controls
                                HStack(spacing: 30) {
                                    Button(action: { /* Previous Action */ }) {
                                        Image(systemName: "backward.fill")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                    }
                                    
                                    Button(action: {
                                        if isSliderEditing {
                                            audioPlayer.play()
                                        } else {
                                            audioPlayer.togglePlayback()
                                        }
                                    }) {
                                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                            .font(.largeTitle)
                                            .foregroundStyle(.white)
                                    }
                                    
                                    Button(action: { /* Next Action */ }) {
                                        Image(systemName: "forward.fill")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .padding(.vertical)
                                .transition(.move(edge: .bottom)) // Move transition for controls
                                
                                Spacer()
                            }
                            .padding()
                            .onAppear {
                                setupAudio()
                            }
                            .offset(y: dragOffset)
                            
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        // Get the drag offset and limit it within the view's height
                                        dragOffset = min(value.translation.height, geometry.size.height / 2)
                                    }
                                    .onEnded { value in
                                        // Dismiss if dragged far enough, or reset
                                        if value.translation.height > geometry.size.height / 4 {
                                            withAnimation(.spring()) {
                                                dragOffset = geometry.size.height
                                                mediaPlayerState.isMediaPlayerExpanded.toggle()
                                            }
                                        } else {
                                            withAnimation(.spring()) {
                                                dragOffset = 0
                                            }
                                        }
                                    }
                            )
                        }
                    } else {
                         // Transition for the mini view
                        miniPlayer
                    }
                }
                .animation(.easeIn(duration: 0.6), value: mediaPlayerState.isMediaPlayerExpanded)
            } else {
                Text("Không có bài hát nào đang phát")
                    .foregroundColor(.gray)
            }
            
           
        }
        .onTapGesture {
            withAnimation(.spring()) {
                mediaPlayerState.isMediaPlayerExpanded.toggle()
                dragOffset = 0
            }
        }
    }
    
    private var miniPlayer: some View {
        HStack {
            AsyncImage(url: URL(string: song.artworkUrl ?? "")) { image in
                image
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(song.title ?? "")
                    .bold()
                Text(song.genre ?? "")
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                if isSliderEditing {
                    audioPlayer.play()
                } else {
                    audioPlayer.togglePlayback()
                }
            }) {
                Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                    .blendMode(.difference)
            }
        }
        .padding()
        .transition(.blurReplace)
    }

    private func setupAudio() {
        Task {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                if let transcoding = song.media?.transcodings.first(where: { $0.format.protocol == "progressive" }) {
                    let streamURL = try await audioPlayer.fetchStreamURL(from: transcoding.url)
                    await MainActor.run {
                        audioPlayer.loadAudio(from: streamURL.absoluteString)
                    }
                } else {
                    print("⚠️ Không tìm thấy stream progressive.")
                }
            } catch {
                print("🚫 Lỗi setup audio: \(error.localizedDescription)")
            }
        }
    }
    
    private func timeString(for seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
