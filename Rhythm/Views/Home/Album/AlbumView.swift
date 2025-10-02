//
//  AlbumView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import SDWebImageSwiftUI

struct AlbumView: View {
    @Environment(\.router) var router
    
    //    var albums: [Album] = Album.sampleData
    
    let sections: [CollectionSectionModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(sections, id: \.urn) { section in
                AlbumSectionView(section: section) {
                    router.showScreen(.push) { _ in
                        PlaylistView()
                    }
                }
            }
        }
    }
}

struct AlbumSectionView: View {
    let section: CollectionSectionModel
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(section.title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(section.items.collection, id: \.id) { playlist in
                        PlaylistArtworkView(urlString: playlist.artworkURL)
                            .padding(10)
                            .onTapGesture { onTap?() }
                    }
                }
            }
            .ignoresSafeArea()
            .scrollTargetLayout()
            .scrollTargetBehavior(.viewAligned)
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

struct PlaylistArtworkView: View {
    let urlString: String?

    var body: some View {
        if let s = urlString, let url = URL(string: s) {
            WebImage(url: url)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.3))
                .scaledToFill()
                .frame(width: 149, height: 169)
                .clipShape(.rect(cornerRadius: 13))
        } else {
            ZStack {
                Color.gray.opacity(0.1)
                Image(systemName: "photo").foregroundColor(.gray)
            }
            .frame(width: 149, height: 169)
            .clipShape(.rect(cornerRadius: 13))
        }
    }
}

#Preview {
    AlbumView(sections: CollectionSectionModel.mockSections)
}
