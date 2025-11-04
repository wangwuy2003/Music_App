//
//  SearchItem.swift
//  Rhythm
//
//  Created by Apple on 3/11/25.
//
import SwiftUI

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
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        if !item.subtitle.isEmpty {
                            Text(item.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                .onTapGesture { onTap(item.id) }
            }
        }
    }
}
