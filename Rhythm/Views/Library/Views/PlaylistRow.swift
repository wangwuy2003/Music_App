//
//  PlaylistItem.swift
//  Rhythm
//
//  Created by Apple on 10/10/25.
//

import SwiftUI

struct PlaylistItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var songs: Int
    var thumb: String?
}

struct PlaylistRow: View {
    let item: PlaylistItem
    
    var onRename: (() -> Void)?
    var onDelete: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 6) {
            Image(item.thumb ?? "coverImage")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(.rect(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
                
                Text("\(item.songs)" + " " + "songs")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 16))
            }
            
            Spacer()
            
            Menu {
                Button {
                    onRename?()
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
                    .foregroundStyle(.white)
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .rotationEffect(Angle(degrees: 90))
            }

        }
    }
}

extension PlaylistRow {
}

#Preview {
    PlaylistRow(item: PlaylistItem(title: "Playlis name", songs: 10, thumb: "coverImage"))
}
