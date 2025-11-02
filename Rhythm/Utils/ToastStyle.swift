//
//  ToastStyle.swift
//  Rhythm
//
//  Created by Apple on 2/11/25.
//
import SwiftUI

enum ToastStyle {
    case success, error, info
}

struct ToastView: View {
    let message: String
    let style: ToastStyle
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .imageScale(.medium)
            
            Text(message)
                .font(.callout)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(backgroundColor)
        .clipShape(Capsule())
        .shadow(radius: 6)
        .padding(.horizontal, 30)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.3), value: message)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .success: return .green.opacity(0.8)
        case .error: return .red.opacity(0.8)
        case .info: return .hex764ED9
        }
    }
    
    private var iconName: String {
        switch style {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.octagon.fill"
        case .info: return ""
        }
    }
}
