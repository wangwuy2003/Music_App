//
//  UploadGridItem.swift
//  Rhythm
//
//  Created by MacMini A6 on 17/11/25.
//
import SwiftUI

struct UploadGridItem: View {
    var playlist: Playlist
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let data = playlist.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                colors: [.mint.opacity(0.6), .white],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 160, height: 160)
                        .overlay(
                            Image("music_ic")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("My Uploads")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("\(playlist.tracks.count)")
                    .font(.system(size: 14))
                    .foregroundColor(.primary.opacity(0.7))
            }
        }
        .frame(width: 160, alignment: .leading)
    }
}
