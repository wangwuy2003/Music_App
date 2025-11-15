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
import SwiftfulLoadingIndicators

struct UploadDetailView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var libraryVM: LibraryViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showMultiImporter = false
    @State private var isEditing: Bool = false
    @State private var selectedTracks: Set<String> = []
    @State private var showDeleteAlert: Bool = false
    
    var playlist: Playlist
    
    @State private var showFileImporter = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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

                        listSection
                    }
                }
            }
            
            // Floating button
            Button {
                if isEditing {
                    showDeleteAlert = true
                } else {
                    showMultiImporter = true
                }
            } label: {
                Image(systemName: isEditing ? "trash" : "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .background(isEditing ? Color.red : Color.accentColor)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding()
            .disabled(isEditing && selectedTracks.isEmpty)
            .opacity(isEditing && selectedTracks.isEmpty ? 0.6 : 1)
            .animation(.easeInOut(duration: 0.2), value: selectedTracks)
            .sheet(isPresented: $showMultiImporter) {
                MultiFileImporter(allowedContentTypes: [.audio]) { urls in
                    for url in urls {
                        libraryVM.handleUploadAudio(from: url)
                    }
                }
            }
            .alert("Delete Selected Songs?",
                   isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deleteSelectedTracks()
                }
            } message: {
                Text("Are you sure you want to delete ?")
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
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation {
                        isEditing.toggle()
                        selectedTracks.removeAll()
                    }
                }
                .foregroundStyle(playlist.tracks.isEmpty ? .gray : .white)
                .disabled(playlist.tracks.isEmpty)
            }
        }
    }
    
    // MARK: - Helper
    private func toggleSelection(for track: SavedTrack) {
        if selectedTracks.contains(track.jamendoID) {
            selectedTracks.remove(track.jamendoID)
        } else {
            selectedTracks.insert(track.jamendoID)
        }
    }
    
    private func deleteSelectedTracks() {
        guard !selectedTracks.isEmpty else { return }
        for track in playlist.tracks where selectedTracks.contains(track.jamendoID) {
            libraryVM.deleteLocalTrack(track, from: playlist)
        }
        selectedTracks.removeAll()
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    private func playTrack(_ track: SavedTrack) {
        var jamendo = track.toJamendoTrack()
        
        // 🔍 Nếu là bài local (audio không bắt đầu bằng http)
        if let audio = jamendo.audio, !audio.hasPrefix("http") {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let localURL = documentsURL.appendingPathComponent("Uploads").appendingPathComponent(audio)
            jamendo.audio = localURL.path
        }
        
        playerVM.startPlayback(from: [jamendo], startingAt: 0)
    }
    
    private func fixTrackURL(_ track: JamendoTrack) -> JamendoTrack {
        guard let audio = track.audio, !audio.hasPrefix("http") else { return track }
        var fixed = track
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let localURL = documentsURL.appendingPathComponent("Uploads").appendingPathComponent(audio)
        fixed.audio = localURL.path
        return fixed
    }
}

// MARK: Subviews
extension UploadDetailView {
    
    // MARK: List Section
    private var listSection: some View {
        List {
            ForEach(playlist.tracks) { track in
                HStack {
                    if isEditing {
                        Image(systemName: selectedTracks.contains(track.jamendoID) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.accentColor)
                            .scaleEffect(selectedTracks.contains(track.jamendoID) ? 1.15 : 1.0)
                            .rotationEffect(.degrees(selectedTracks.contains(track.jamendoID) ? 360 : 0))
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedTracks)
                            .onTapGesture {
                                toggleSelection(for: track)
                            }
                    }
                    
                    if !isEditing && playerVM.currentTrack?.id == track.jamendoID {
                        LoadingIndicator(animation: .fiveLinesCenter, color: .pink, size: .small, speed: .normal)
                    } else {
                        Image("red_music_ic")
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(track.name)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .lineLimit(2)
                        if let duration = track.duration {
                            Text(formatTime(Double(duration)))
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.6))
                        }
                    }
                    
                    Spacer()
                    
                    if !isEditing {
                        Menu {
                            Button(role: .destructive) {
                                libraryVM.confirmDeleteLocalTrack(track, from: playlist)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .foregroundStyle(.white)
                                .padding(12)
                                .contentShape(Rectangle())
                        }
                    }
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    if isEditing {
                        toggleSelection(for: track)
                    } else {
                        playTrack(track)
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let track = playlist.tracks[index]
                    libraryVM.confirmDeleteLocalTrack(track, from: playlist)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.inset)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 50)
        }
    }
    
    // MARK: Button section
    private var buttonSection: some View {
        HStack(spacing: 25) {
            Button {
                print("▶️ Phát playlist")
                let allTracks = playlist.tracks.map { fixTrackURL($0.toJamendoTrack()) }
                guard !allTracks.isEmpty else { return }
                playerVM.startPlayback(from: allTracks, startingAt: 0)
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
                var shuffled = playlist.tracks.map { fixTrackURL($0.toJamendoTrack()) }
                guard !shuffled.isEmpty else { return }
                shuffled.shuffle()
                playerVM.startPlayback(from: shuffled, startingAt: 0)
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
