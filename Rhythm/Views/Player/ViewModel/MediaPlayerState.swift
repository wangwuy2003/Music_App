import SwiftUI
import AVFAudio

final class MediaPlayerState: ObservableObject {
    @Published var isMediaPlayerShown: Bool = false
    @Published var isMediaPlayerExpanded: Bool = false
    @Published var currentTrack: TrackModel?
    
    let audioPlayer = AudioPlayer()
    
    func play(track: TrackModel) {
        currentTrack = track
        isMediaPlayerExpanded = true
        isMediaPlayerShown = true
        
        Task {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                guard let transcoding = track.media?.transcodings.first(where: { $0.format.protocol == "progressive" }) else {
                    print("⚠️ Không tìm thấy stream progressive.")
                    return
                }
                
                // Gọi API để lấy URL phát thực tế
                let streamURL = try await audioPlayer.fetchStreamURL(from: transcoding.url)
                
                // Load và phát nhạc
                await MainActor.run {
                    audioPlayer.loadAudio(from: streamURL.absoluteString)
                    audioPlayer.play()
                }
            } catch {
                print("🚫 Lỗi phát nhạc: \(error.localizedDescription)")
            }
        }
    }
}
