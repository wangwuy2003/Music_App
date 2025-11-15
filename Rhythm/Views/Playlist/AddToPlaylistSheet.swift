//
//  AddToPlaylistSheet.swift
//  Rhythm
//
//  Created by MacMini A6 on 31/10/25.
//

import SwiftUI
import SwiftData

struct AddToPlaylistSheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var searchText: String = ""
    @State private var isShowingAddPlaylist: Bool = false
    @Query private var playlists: [Playlist]
    
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    
    let track: JamendoTrack
    
    var filteredPlaylists: [Playlist] {
        if searchText.isEmpty {
            return playlists
        } else {
            return playlists.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    isShowingAddPlaylist = true
                } label: {
                    HStack(spacing: 5) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 50, height: 50)
                            .overlay(Image(systemName: "plus").foregroundStyle(.accent))
                        
                        Text(.localized("New playlist"))
                            .fontWeight(.medium)
                    }
                    
                }
                .padding(.horizontal, 20)
                .buttonStyle(.plain)
                
                List {
                    ForEach(playlists) { playlist in
                        if playlist.name != "My Uploads" {
                            Button {
                                addTrack(to: playlist)
                            } label: {
                                HStack {
                                    if let data = playlist.imageData, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 50, height: 50)
                                            .overlay(Image(systemName: "music.note.list"))
                                    }
                                    
                                    Text(playlist.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
            .navigationTitle("Add to Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: Text(.localized("Search Playlists")))
            .toast(isPresented: $showToast, message: toastMessage)
        }
        .sheet(isPresented: $isShowingAddPlaylist) {
            AddPlaylistView()
        }
    }
    
    private func addTrack(to playlist: Playlist) {
        // ⚙️ Kiểm tra xem playlist đã có bài này chưa
        let isDuplicate = playlist.tracks.contains {
            $0.name.lowercased() == track.name.lowercased() || $0.jamendoID == track.id
        }

        if isDuplicate {
            // 🚫 Báo đã có sẵn, không thêm trùng
            showAddPlaylistMessage("⚠️ \"\(track.name)\" is already in \(playlist.name)")
            return
        }

        // ✅ Tạo bản sao độc lập của track
        let copy = JamendoTrack(
            id: UUID().uuidString, // id mới để tránh trùng
            name: track.name,
            albumId: track.albumId,
            duration: track.duration,
            artistName: track.artistName,
            albumImage: track.albumImage,
            image: track.image,
            audio: track.audio,
            audioDownload: track.audioDownload
        )
        
        // ✅ Tạo SavedTrack mới gắn vào playlist đích
        let newTrack = SavedTrack(jamendoTrack: copy, playlist: playlist)
        modelContext.insert(newTrack)

        do {
            try modelContext.save()
            print("✅ Copied \(track.name) to \(playlist.name)")
            showAddPlaylistMessage("🎶 Added to \(playlist.name)")
            
            // Tự đóng sheet sau 3 giây
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                dismiss()
            }
        } catch {
            print("❌ Failed to add track: \(error.localizedDescription)")
        }
    }
    
    func showAddPlaylistMessage(_ message: String) {
        toastMessage = message
        withAnimation { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation { showToast = false }
        }
    }
}
