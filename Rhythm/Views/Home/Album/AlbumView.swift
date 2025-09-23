//
//  AlbumView.swift
//  Music_App
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

struct AlbumView: View {
    @Environment(\.router) var router
    
    var albums: [Album] = Album.sampleData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(albums) { album in
                AlbumSectionView(album: album) {
                    router.showScreen(.push) { _ in
                        PlaylistView()
                    }
                }
            }
        }
    }
}

struct AlbumSectionView: View {
    let album: Album
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(album.title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(album.imageName, id: \.self) { name in
                        Image(name)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 149, height: 169)
                            .clipShape(.rect(cornerRadius: 13))
                            .padding(10)
                            .id(name)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.6)
                            }
                            .onTapGesture {
                                onTap?()
                            }
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

#Preview {
    AlbumView()
}
