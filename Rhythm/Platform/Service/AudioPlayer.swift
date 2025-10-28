import Foundation
import AVFoundation
import Combine

final class AudioPlayer: ObservableObject {
    private var player: AVPlayer?
    private var timeObserverToken: Any?
    private var cancellables = Set<AnyCancellable>()

    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var isPlaying: Bool = false
    @Published var isReady: Bool = false

    // MARK: - Load audio (HLS)
    func loadAudio(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // Lắng nghe trạng thái player
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

    // MARK: - Control
    func play() {
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func togglePlayback() {
        isPlaying ? pause() : play()
    }

    func seek(to time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 1))
    }

    // MARK: - Time Tracking
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
        }
    }

    // MARK: - Clean up
    deinit {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
        }
    }

    // MARK: - Fetch Stream URL (HLS)
    func fetchStreamURL(from transcodingURL: String) async throws -> URL {
        let apiURL = URL(string: "\(transcodingURL)?client_id=\(Constant.clientId)")!
        let (data, _) = try await URLSession.shared.data(from: apiURL)
        let response = try JSONDecoder().decode(StreamResponse.self, from: data)
        return URL(string: response.url)!
    }
}
