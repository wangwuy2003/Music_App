//
//  PlaylistItem.swift
//  Rhythm
//
//  Created by Apple on 10/10/25.
//

import SwiftUI
import SwiftData

struct PlaylistRow: View {
    let playlist: Playlist
    var onDelete: (() -> Void)?
    var onPlay: (() -> Void)?
    var onShuffle: (() -> Void)?
    var onEdit: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if let data = playlist.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                ZStack {
                    Color.gray.opacity(0.3)
                    Image(systemName: "music.note.list")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(playlist.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                Text("\(playlist.tracks.count) song\(playlist.tracks.count == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(.clear)
            
            Spacer()
            
            Menu {
                Button {
                    onPlay?()
                } label: {
                    Label(.localized("Play"), systemImage: "play")
                }
                
                Button {
                    onShuffle?()
                } label: {
                    Label(.localized("Shuffle"), systemImage: "shuffle")
                }
                
                Button {
                    onEdit?()
                } label: {
                    Label(.localized("Edit"), systemImage: "pencil")
                }
                
                Button(role: .destructive) {
                    onDelete?()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .padding(8)
            }
            .labelStyle(.titleAndIcon)
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
    }
}

#Preview {
    LibraryView()
        .modelContainer(for: [Playlist.self, SavedTrack.self])
}
