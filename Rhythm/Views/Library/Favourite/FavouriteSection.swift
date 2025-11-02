//
//  FavouritesRow.swift
//  Rhythm
//
//  Created by Apple on 1/11/25.
//
import SwiftUI

struct FavouriteSection: View {
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(
                        colors: [.pink, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)
                Image(systemName: "heart.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            Text(.localized("Favourite Songs"))
                .font(.headline)
                .foregroundStyle(.white)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}
