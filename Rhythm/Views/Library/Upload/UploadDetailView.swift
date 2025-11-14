//
//  UploadDetailView.swift
//  Rhythm
//
//  Created by MacMini A6 on 14/11/25.
//


import SwiftUI
import SwiftData
import AVFoundation
import UniformTypeIdentifiers

struct UploadDetailView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var libraryVM: LibraryViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    var playlist: Playlist
    var onPlay: (() -> Void)?
    var onShuffle: (() -> Void)?
    
    @State private var showFileImporter = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                if playlist.tracks.isEmpty {
                    ContentUnavailableView(
                        "No uploaded songs yet",
                        systemImage: "tray",
                        description: Text("Tap the Upload button to add your own songs")
                    )
                } else {
                    VStack(spacing: 15) {
                        buttonSection
                        
                        List {
                            ForEach(playlist.tracks) { track in
                                HStack {
                                    Image("red_music_ic")
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(track.name)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        if let duration = track.duration {
                                            Text(formatTime(Double(duration)))
                                                .font(.caption)
                                                .foregroundStyle(.white.opacity(0.6))
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        let jamendo = track.toJamendoTrack()
                                        playerVM.startPlayback(from: [jamendo], startingAt: 0)
                                    } label: {
                                        Image(systemName: "play.fill")
                                            .foregroundStyle(.white)
                                    }
                                }
                                .padding(.vertical, 4)
                                .listRowBackground(Color.clear)
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    let track = playlist.tracks[index]
                                    modelContext.delete(track)
                                }
                                try? modelContext.save()
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.inset)
                    }
                }
            }
        }
        .enableSwipeBack()
        .navigationBarBackButtonHidden()
        .navigationTitle("My Uploads")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showFileImporter = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                }
            }
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.audio]
        ) { result in
            switch result {
            case .success(let url):
                libraryVM.handleUploadAudio(from: url)
            case .failure(let error):
                print("❌ Upload failed:", error.localizedDescription)
            }
        }
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

// MARK: Subviews
extension UploadDetailView {
    private var buttonSection: some View {
        HStack(spacing: 25) {
            Button {
                print("▶️ Phát playlist")
                onPlay?()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "play.fill")
                    Text(.localized("Play"))
                        .fontWeight(.semibold)
                }
                .frame(width: 150, height: 45)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(Capsule())
            }
            
            Button {
                print("🔀 Xáo trộn playlist")
                onShuffle?()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "shuffle")
                    Text(.localized("Random"))
                        .fontWeight(.semibold)
                }
                .frame(width: 150, height: 45)
                .background(Color.white.opacity(0.1))
                .foregroundStyle(.accent)
                .clipShape(Capsule())
            }
        }
        .padding(.top, 8)
        .buttonStyle(.borderless)
        
    }
}
