//
//  Color+Gradient.swift
//  Rhythm
//
//  Created by MacMini A6 on 13/11/25.
//

import SwiftUI

extension LinearGradient {
    static func randomDark() -> LinearGradient {
        // Các cặp màu tối — bạn có thể thêm nhiều hơn tùy phong cách app
        let darkGradients: [(Color, Color)] = [
            (.indigo.opacity(0.8), .black),
            (.purple.opacity(0.8), .black),
            (.blue.opacity(0.7), .black),
            (.teal.opacity(0.7), .black),
            (.gray.opacity(0.6), .black),
            (.brown.opacity(0.7), .black),
            (.mint.opacity(0.6), .black),
            (.cyan.opacity(0.7), .black)
        ]
        
        // Chọn ngẫu nhiên 1 cặp màu
        let pair = darkGradients.randomElement() ?? (.indigo.opacity(0.8), .black)
        
        return LinearGradient(
            gradient: Gradient(colors: [pair.0, pair.1]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
