//
//  AlbumSquareView.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//
import SwiftUI
import SDWebImageSwiftUI

struct AlbumSquareView: View {
    let album: JamendoAlbum
    private let squareSize: CGFloat = 150

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            WebImage(url: URL(string: album.image))
                .resizable()
                .indicator(.activity)
                .transition(.fade)
                .scaledToFill()
                .frame(width: squareSize, height: squareSize)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 5)
            
            Text(album.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(album.artistName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: squareSize)
    }
}
