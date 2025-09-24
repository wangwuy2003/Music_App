//
//  MusicView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

struct MusicView: View {
    @Environment(\.router) var router
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.secondary)
                    .frame(width: 70, height: 6)
                    .padding(.vertical, 12)
                
                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        dragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height > 150 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                            dragOffset = 1000 // trượt xuống dưới
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            router.dismissScreen()
                        }
                    } else {
                        // quay lại vị trí ban đầu
                        withAnimation {
                            dragOffset = 0
                        }
                    }
                }
        )
    }
}

#Preview {
    MusicView()
}
