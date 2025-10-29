//
//  PlayerViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 24/9/25.
//

import SwiftUI
import AVFoundation
import Combine

@MainActor
final class PlayerViewModel: ObservableObject {
    @Published var isBarPresented = false
    @Published var isPopupOpen = false
    @Published var currentTrack: JamendoTrack?
    @Published var popupArtwork: Image = Image(systemName: "music.note")

    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var isPlaying: Bool = false
    @Published var isReady: Bool = false
    
    private var player: AVPlayer?
    private var timeObserverToken: Any?
    private var cancellables = Set<AnyCancellable>()
    
    var title: String { currentTrack?.name ?? "Unknown Name" }
    var subtitle: String {currentTrack?.artistName ?? "Unknown Artist" }
    var artwork: String? { currentTrack?.image }

    deinit {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
        }
    }
    
    func play(track: JamendoTrack) {
        player?.pause()
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
        player = nil
        cancellables.removeAll()
        
        currentTrack = track
        isBarPresented = true
        isReady = false
        currentTime = 0
        duration = 0
        isPlaying = false
        
        loadPopupArtwork()

        Task {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                loadAudio(from: track.audio ?? "")
            } catch {
                print("🚫 Lỗi phát nhạc:", error.localizedDescription)
            }
        }
    }

    func loadPopupArtwork() {
        guard let artwork = artwork, !artwork.isEmpty,
              let url = URL(string: artwork) else {
            popupArtwork = Image(systemName: "music.note")
            return
        }

        Task.detached {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.popupArtwork = Image(uiImage: uiImage)
                    }
                }
            } catch {
                print("⚠️ Không thể tải ảnh popup:", error.localizedDescription)
            }
        }
    }

    // ===============================================
    // MARK: - Player Controls
    // ===============================================

    func loadAudio(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        playerItem.publisher(for: \.status)
            .sink { [weak self] status in
                guard let self = self else { return }
                if status == .readyToPlay {
                    self.duration = playerItem.asset.duration.seconds
                    self.isReady = true
                    self.play()
                }
            }
            .store(in: &cancellables)

        addTimeObserver()
    }

    func play() {
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func seek(to time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 1))
    }

    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
        }
    }
}
