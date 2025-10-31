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
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if let data = playlist.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                ZStack {
                    Color.gray.opacity(0.3)
                    Image(systemName: "music.note.list")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(playlist.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Menu {
                Button {
                } label: {
                    Label("Rename", systemImage: "pencil")
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
        }
    }
}

#Preview {
    LibraryView()
        .modelContainer(for: [Playlist.self, SavedTrack.self])
}
