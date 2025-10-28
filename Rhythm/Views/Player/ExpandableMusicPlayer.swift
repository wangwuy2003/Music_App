//
//  ExpandableMusicPlayer.swift
//  Rhythm
//
//  Created by MacMini A6 on 28/10/25.
//

import SwiftUI

struct ExpandableMusicPlayer: View {
    @Binding var show: Bool
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack(alignment: .top) {
                /// mini player
                miniPlayer()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, safeArea.bottom + 55)
            .padding(.horizontal, 15)
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func miniPlayer() -> some View {
        HStack(spacing: 12) {
            Image(.cover)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(.rect(cornerRadius: 10))
            
            Text("Calm Down")
            
            Spacer()
            
            Group {
                Button("", systemImage: "play.fill") {
                    
                }
                
                Button("", systemImage: "forward.fill") {
                    
                }
            }
            .font(.title3)
            .foregroundStyle(Color.primary)
        }
        .padding(.horizontal, 10)
        .frame(height: 55)
        .background(.red)
    }
}

#Preview {
    RootView {
        TabbarView()
    }
//    ExpandableMusicPlayer(show: .constant(true))
}
