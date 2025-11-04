//
//  SearchItem.swift
//  Rhythm
//
//  Created by Apple on 3/11/25.
//
import SwiftUI

enum SearchType {
    case track
    case album
    case artist
    case playlist
}

struct SearchItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let imageURL: String?
}

struct SearchSectionView: View {
    let title: String
    let items: [SearchItem]
    let onTap: (String) -> Void
    let type: SearchType

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(items) { item in
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: item.imageURL ?? "")) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                            .overlay {
                                Image(systemName: "music.quarternote.3")
                            }
                    }
                    .frame(width: 55, height: 55)
                    .conditionalClipShape(isCircle: type == .artist)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        if type == .album || type == .artist, !item.subtitle.isEmpty {
                            Text(item.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    
                    if type == .track {
                        Image(systemName: "play.circle.fill")
                            .foregroundStyle(.accent)
                            .font(.title2)
                            .onTapGesture {
                                onTap(item.id)
                            }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onTap(item.id)
                }
            }
        }
    }
}
