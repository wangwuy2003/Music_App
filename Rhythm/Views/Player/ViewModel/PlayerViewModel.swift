//
//  PlayerViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 24/9/25.
//

import SwiftUI
import AVFoundation
import Combine
import MediaPlayer
import SwiftData
import FirebaseAuth

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
    
    @Published var repeatMode: RepeatMode = .none
    
    @Published var isFavourite: Bool = false
    @Published var favourites: [FavouriteTrack] = []
    
    private var player: AVPlayer?
    private var timeObserverToken: Any?
    private var cancellables = Set<AnyCancellable>()
    
    var title: String { currentTrack?.name ?? "Unknown Name" }
    var subtitle: String {currentTrack?.artistName ?? "Unknown Artist" }
    var artwork: String? { currentTrack?.image }
    
    private var modelContext: ModelContext?
    
    func attachModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

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
        self.isPlaying = true
        self.play(track: tracks[index])
    }
    
    private func play(track: JamendoTrack) {
        let wasPlaying = self.isPlaying
        
        player?.pause()
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
        player = nil
        cancellables.removeAll()
        
        currentTrack = track
        
        // log event "play"
        if let uid = Auth.auth().currentUser?.uid {
            FirestoreManager.shared.logListeningEvent(uid: uid, trackId: track.id, type: "play")
        }
        
        if let user = Auth.auth().currentUser {
            print("👤 UID:", user.uid)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.checkIfFavourite()
        }
        isBarPresented = true
        isReady = false
        currentTime = 0
        duration = 0
//        isPlaying = false
        self.isPlaying = wasPlaying
        
        loadPopupArtwork()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("🚫 Lỗi cấu hình AVAudioSession:", error.localizedDescription)
        }

        Task {
            guard let audioURLString = track.audio else {
                print("🚫 Lỗi: Track này không có link audio.")
                self.playNext()
                return
            }

            loadAudio(from: audioURLString, shouldPlayImmediately: wasPlaying)
           
        }
        
        setupRemoteTransportControls()
        setupNowPlayingInfo()
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
    
    // MARK: State
    func saveState() {
        guard let track = currentTrack else {
            return
        }
        
        let state = PlayerState(
            currentTrack: track,
            currentTime: currentTime,
            currentQueue: currentQueue,
            currentIndex: currentIndex
        )
        
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: "PlayerState")
        }
    }
    
    func restoreState() {
        if let data = UserDefaults.standard.data(forKey: "PlayerState"),
           let state = try? JSONDecoder().decode(PlayerState.self, from: data) {
            self.currentQueue = state.currentQueue
            self.currentIndex = state.currentIndex
            self.currentTrack = state.currentTrack
            self.currentTime = state.currentTime
            self.isBarPresented = true
            self.isPlaying = false
            
            do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.playback, mode: .default)
                try audioSession.setActive(true)
            } catch {
                print("🚫 Lỗi kích hoạt AVAudioSession khi restore:", error.localizedDescription)
            }
            
            loadAudio(from: state.currentTrack.audio ?? "", shouldPlayImmediately: false)
            seek(to: state.currentTime)
            loadPopupArtwork()
        }
    }
    
    func toggleRepeatMode() {
        switch repeatMode {
        case .none:
            repeatMode = .repeatAll
        case .repeatAll:
            repeatMode = .repeatOne
        case .repeatOne:
            repeatMode = .none
        }
        print("🔁 Repeat mode: \(repeatMode)")
    }
    
    // MARK: Favourite
    func checkIfFavourite() {
        guard let track = currentTrack,
        let modelContext = modelContext else {
            isFavourite = false
            return
        }

        let fetchDescriptor = FetchDescriptor<FavouriteTrack>(
            predicate: #Predicate { $0.jamendoID == track.id }
        )

        do {
            let results = try modelContext.fetch(fetchDescriptor)
            isFavourite = !results.isEmpty
        } catch {
            print("⚠️ Lỗi kiểm tra yêu thích:", error.localizedDescription)
            isFavourite = false
        }
    }
    
    func toggleFavourite() {
        guard let track = currentTrack,
              let modelContext = modelContext else {
            return
        }
        
        let fetchDescriptor = FetchDescriptor<FavouriteTrack>(
            predicate: #Predicate { $0.jamendoID == track.id }
        )
        
        do {
            let existing = try modelContext.fetch(fetchDescriptor)

            if let fav = existing.first {
                modelContext.delete(fav)
                isFavourite = false
            } else {
                let newFav = FavouriteTrack(jamendoTrack: track)
                modelContext.insert(newFav)
                isFavourite = true
                
                // log event favourite
                if let uid = Auth.auth().currentUser?.uid {
                    FirestoreManager.shared.logListeningEvent(uid: uid, trackId: track.id, type: "like")
                }
            }

            try modelContext.save()
        } catch {
            print("❌ Lỗi khi lưu/xóa bài hát yêu thích:", error.localizedDescription)
        }
    }

    // ===============================================
    // MARK: - Player Controls
    // ===============================================
    func setupNowPlayingInfo() {
        guard let track = currentTrack else {
            return
        }
        
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: track.name,
            MPMediaItemPropertyArtist: track.artistName ?? "Unknown Artist",
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]
        
        if duration > 0 {
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        if let imageUrl = track.image, let url = URL(string: imageUrl) {
            Task.detached {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
                        await MainActor.run {
                            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                        }
                    }
                } catch {
                    print("⚠️ Không thể tải ảnh artwork:", error.localizedDescription)
                }
            }
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }

        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.playNext()
            return .success
        }

        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.playPrevious()
            return .success
        }

        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.togglePlayback()
            return .success
        }
    }

    func loadAudio(from urlString: String, shouldPlayImmediately: Bool) {
        guard let url = URL(string: urlString) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification, object: playerItem)
            .sink { [weak self] _ in
                print("🎶 Bài hát kết thúc, tự động chuyển bài...")
                // log event complete
                if let uid = Auth.auth().currentUser?.uid,
                   let trackId = self?.currentTrack?.id {
                    FirestoreManager.shared.logListeningEvent(uid: uid, trackId: trackId, type: "complete")
                }
                self?.playNext()
            }
            .store(in: &cancellables)

        playerItem.publisher(for: \.status)
            .sink { [weak self] status in
                guard let self = self else { return }
                if status == .readyToPlay {
                    self.duration = playerItem.asset.duration.seconds
                    self.isReady = true
                    
                    if shouldPlayImmediately {
                        self.play()
                    } else {
                        self.isPlaying = false
                    }
                }
            }
            .store(in: &cancellables)

        addTimeObserver()
    }

    func play() {
        player?.play()
        setupNowPlayingInfo()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        setupNowPlayingInfo()
        isPlaying = false
    }

    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            if player == nil, let track = currentTrack {
                 play(track: track)
            } else {
                 play()
            }
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
        
        switch repeatMode {
        case .none:
            if nextIndex < currentQueue.count {
                self.currentIndex = nextIndex
                play(track: currentQueue[currentIndex])
            } else {
                player?.pause()
                seek(to: 0)
                isPlaying = false
                print("🏁 Hết hàng đợi.")
                return
            }
        case .repeatAll:
            if nextIndex >= currentQueue.count {
                currentIndex = 0
                self.play(track: currentQueue[currentIndex])
            } else {
                self.currentIndex = nextIndex
                play(track: currentQueue[currentIndex])
            }
        case .repeatOne:
            seek(to: 0)
            self.play()
            return
        }
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
    
    // MARK: - Queue management:
    func addToQueue(_ track: JamendoTrack) {
        guard !currentQueue.contains(where: { $0.id == track.id }) else {
            print("⚠️ Track đã tồn tại trong queue, bỏ qua.")
            return
        }
        
        currentQueue.append(track)
        print("✅ Đã thêm vào cuối queue: \(track.name)")
    }
    
    func addToQueueNext(_ track: JamendoTrack) {
        guard !currentQueue.contains(where: { $0.id == track.id }) else {
            print("⚠️ Track đã tồn tại trong queue, bỏ qua.")
            return
        }
        
        guard !currentQueue.isEmpty else {
            startPlayback(from: [track], startingAt: 0)
            return
        }
        
        let insertIndex = min(currentIndex + 1, currentQueue.count)
        currentQueue.insert(track, at: insertIndex)
        print("✅ Đã thêm vào ngay sau bài hiện tại: \(track.name)")
    }
}

enum RepeatMode {
    case none
    case repeatAll
    case repeatOne
}
