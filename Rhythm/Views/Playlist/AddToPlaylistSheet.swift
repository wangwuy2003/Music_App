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
    @Query private var playlists: [Playlist]
    
    let track: JamendoTrack
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(playlists) { playlist in
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
            .navigationTitle("Add to Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addTrack(to playlist: Playlist) {
        let newTrack = SavedTrack(jamendoTrack: track, playlist: playlist)
        modelContext.insert(newTrack)
        
        do {
            try modelContext.save()
            print("✅ Đã thêm \(track.name) vào \(playlist.name)")
            dismiss()
        } catch {
            print("❌ Lỗi thêm track: \(error.localizedDescription)")
        }
    }
}
