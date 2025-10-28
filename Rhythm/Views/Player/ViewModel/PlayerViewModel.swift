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
    @Published var currentTrack: TrackModel?
    @Published var popupArtwork: Image = Image(systemName: "music.note")
    @Published var audioPlayer = AudioPlayer()
    
    private var cancellables = Set<AnyCancellable>()

    var title: String { currentTrack?.title ?? "Not Playing" }
    var subtitle: String { currentTrack?.user?.full_name ?? "" }
    var artwork: String? { currentTrack?.artworkUrl }
    
    init() {
        audioPlayer.objectWillChange
            .sink { [weak self] _ in
                // Khi audioPlayer thay đổi, báo cho PlayerViewModel
                // (và bất kỳ View nào đang theo dõi nó) cũng thay đổi
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    // MARK: - Play track
    func play(track: TrackModel) {
        currentTrack = track
        isBarPresented = true
        loadPopupArtwork()

        Task {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                guard let transcoding = track.media?.transcodings.first(where: { $0.format.protocol == "hls" }) else {
                    print("⚠️ Không tìm thấy stream HLS.")
                    return
                }

                let streamURL = try await audioPlayer.fetchStreamURL(from: transcoding.url)
                audioPlayer.loadAudio(from: streamURL.absoluteString)
            } catch {
                print("🚫 Lỗi phát nhạc:", error.localizedDescription)
            }
        }
    }

    func togglePlayback() {
        audioPlayer.togglePlayback()
    }

    // MARK: - Artwork
    func loadPopupArtwork() {
        guard let artwork = artwork,
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
}
