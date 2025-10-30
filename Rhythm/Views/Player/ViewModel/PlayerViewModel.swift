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
    
    @Published var currentQueue: [JamendoTrack] = []
    @Published var currentIndex: Int = 0
    
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
        
        cancellables.forEach { $0.cancel() }
        NotificationCenter.default.removeObserver(self)
    }
    
    func startPlayback(from tracks: [JamendoTrack], startingAt index: Int) {
        guard index >= 0 && index < tracks.count else { return }
                
        self.currentQueue = tracks
        self.currentIndex = index
        self.play(track: tracks[index])
    }
    
    private func play(track: JamendoTrack) {
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

                guard let audioURLString = track.audio else {
                    print("🚫 Lỗi: Track này không có link audio.")
                    self.playNext()
                    return
                }

                loadAudio(from: audioURLString)
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
        
        NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification, object: playerItem)
            .sink { [weak self] _ in
                print("🎶 Bài hát kết thúc, tự động chuyển bài...")
                self?.playNext()
            }
            .store(in: &cancellables)

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
    
    func playNext() {
        guard !currentQueue.isEmpty else {
            return
        }
        
        let nextIndex = currentIndex + 1
        
        guard nextIndex < currentQueue.count else {
            player?.pause()
            seek(to: 0)
            isPlaying = false
            print("🏁 Hết hàng đợi.")
            return
        }
        
        self.currentIndex = nextIndex
        self.play(track: currentQueue[currentIndex])
    }
    
    func playPrevious() {
        guard !currentQueue.isEmpty else { return }
        
        if currentTime > 3 {
            seek(to: 0)
            play()
            return
        }
        
        let prevIndex = currentIndex - 1
        
        guard prevIndex >= 0 else {
            seek(to: 0)
            play()
            return
        }
        
        self.currentIndex = prevIndex
        self.play(track: currentQueue[currentIndex])
    }
}
