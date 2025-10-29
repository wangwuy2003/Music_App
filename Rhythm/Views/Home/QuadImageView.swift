//
//  QuadImageView.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import SwiftUI
import SDWebImageSwiftUI

struct QuadImageView: View {
    let images: [String?] // Mảng 4 URL ảnh
    
    var body: some View {
        GeometryReader { geo in
            let imageSize = geo.size.width / 2
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    // Top-Left
                    imageCell(url: images.indices.contains(0) ? images[0] : nil, size: imageSize)
                    // Top-Right
                    imageCell(url: images.indices.contains(1) ? images[1] : nil, size: imageSize)
                }
                HStack(spacing: 0) {
                    // Bottom-Left
                    imageCell(url: images.indices.contains(2) ? images[2] : nil, size: imageSize)
                    // Bottom-Right
                    imageCell(url: images.indices.contains(3) ? images[3] : nil, size: imageSize)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit) // Giữ hình vuông
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 5)
    }
    
    @ViewBuilder
    private func imageCell(url: String?, size: CGFloat) -> some View {
        // Dùng (url ?? "") để WebImage không báo lỗi
        WebImage(url: URL(string: url ?? ""))
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: size, height: size)
            .clipped() // Cắt ảnh để vừa khít ô
            .background(.gray.opacity(0.3)) // Nền placeholder
    }
}