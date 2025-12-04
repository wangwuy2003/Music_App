//
//  Color+Gradient.swift
//  Rhythm
//
//  Created by MacMini A6 on 13/11/25.
//

import SwiftUI

extension LinearGradient {
    static func randomDark(endColor: Color = .black) -> LinearGradient {
        let darkGradients: [(Color, Color)] = [
            (.indigo.opacity(0.8), endColor),
            (.purple.opacity(0.8), endColor),
            (.blue.opacity(0.7), endColor),
            (.teal.opacity(0.7), endColor),
            (.gray.opacity(0.6), endColor),
            (.brown.opacity(0.7), endColor),
            (.mint.opacity(0.6), endColor),
            (.cyan.opacity(0.7), endColor)
        ]
        
        // Lấy ngẫu nhiên một cặp màu, nhưng thay màu thứ 2 bằng endColor truyền vào
        let pair = darkGradients.randomElement() ?? (.indigo.opacity(0.8), endColor)
        
        return LinearGradient(
            gradient: Gradient(colors: [pair.0, endColor]), // Dùng endColor động
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
