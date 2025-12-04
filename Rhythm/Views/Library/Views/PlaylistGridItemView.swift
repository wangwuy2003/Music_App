//
//  PlaylistGridItemView.swift
//  Rhythm
//
//  Created by MacMini A6 on 17/11/25.
//
import SwiftUI

struct PlaylistGridRowItem: View {
    var image: Image?
    var title: String
    var count: Int
    var icon: String? = nil
    var iconColor: Color = .red
    var gradientColors: [Color]? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let gradientColors = gradientColors {
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: 160, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                if let image = image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                        )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(" \(count) songs")
                    .font(.system(size: 14))
                    .foregroundColor(.primary.opacity(0.7))
            }
        }
        .frame(width: 160, alignment: .leading)
    }
}
