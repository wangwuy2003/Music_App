//
//  TrackRowView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftfulRouting

//struct TrackRowView: View {
//    @EnvironmentObject var playerVM: PlayerViewModel
//    @Environment(\.router) var router
//    let track: TrackModel
//    
//    var body: some View {
//        HStack(spacing: 12) {
//            if let url = URL(string: track.artworkUrl ?? "") {
//                WebImage(url: url)
//                    .resizable()
//                    .indicator(.activity)
//                    .transition(.fade(duration: 0.3))
//                    .scaledToFill()
//                    .frame(width: 50, height: 50)
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//            } else {
//                ZStack {
//                    Color.gray.opacity(0.2)
//                    Image(systemName: "music.note")
//                        .font(.system(size: 20))
//                        .foregroundColor(.gray)
//                }
//                .frame(width: 50, height: 50)
//                .clipShape(RoundedRectangle(cornerRadius: 8))
//            }
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text(track.title ?? "Unknown title")
//                    .font(.headline)
//                    .lineLimit(1)
//                
//                Text(track.user?.full_name ?? "Unknown username")
//                    .font(.subheadline)
//                    .lineLimit(1)
//                    .foregroundStyle(.secondary)
//            }
//            
//            Spacer()
//            
//            VStack(alignment: .trailing, spacing: 6) {
//                Text(formatDuration(track.duration))
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//                
//                HStack(spacing: 6) {
//                    Image(systemName: "play.fill")
//                        .font(.caption2)
//                    
//                    Text(formatPlayCount(track.playbackCount))
//                        .font(.subheadline)
//                        .foregroundStyle(.secondary)
//                }
//            }
//            .frame(minWidth: 72, alignment: .trailing)
//        }
//        .onTapGesture {
//            playSelectedTrack()
//        }
//    }
//}
//
//extension TrackRowView {
//    func playSelectedTrack() {
//        playerVM.play(track: track)
//        print("Yolo: \(track.id)")
//    }
//    
//    // MARK: - Format Duration
//    private func formatDuration(_ duration: Int?) -> String {
//        guard let duration = duration else { return "--:--" }
//        let totalSeconds = duration / 1000
//        let minutes = totalSeconds / 60
//        let seconds = totalSeconds % 60
//        return String(format: "%d:%02d", minutes, seconds)
//    }
//    
//    // MARK: - Format Play Count
//    private func formatPlayCount(_ count: Int?) -> String {
//        guard let count = count else { return "0" }
//        switch count {
//        case 1_000_000...:
//            return String(format: "%.1fM", Double(count) / 1_000_000)
//        case 1_000...:
//            return String(format: "%.1fK", Double(count) / 1_000)
//        default:
//            return "\(count)"
//        }
//    }
//}

// ✅ VIEW MỚI: Dùng cho mỗi hàng track (thay thế TrackRowView cũ)
struct TrackRowView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    let track: JamendoTrack

    var body: some View {
        HStack(spacing: 12) {
            WebImage(url: URL(string: track.image ?? ""))
                .resizable()
                .indicator(.activity)
                .transition(.fade)
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(track.name)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                
                Text("Unknown")
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text(formatDuration(track.duration ?? 00))
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
//        .padding(.horizontal)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
    
    // Helper format thời gian
    private func formatDuration(_ seconds: Int) -> String {
        let total = seconds
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
