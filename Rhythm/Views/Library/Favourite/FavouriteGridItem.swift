//
//  FavouriteGridItem.swift
//  Rhythm
//
//  Created by MacMini A6 on 17/11/25.
//
import SwiftUI

struct FavouriteGridItem: View {
    var tracks: [FavouriteTrack]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.8), .black],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Favourite Songs")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("\(tracks.count) songs")
                    .font(.system(size: 14))
                    .foregroundColor(.primary.opacity(0.7))
            }
        }
        .frame(width: 160, alignment: .leading)
    }
}
