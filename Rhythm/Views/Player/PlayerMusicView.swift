//
//  MusicView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

struct PlayerMusicView: View {
    @Environment(\.router) var router
    @State private var dragOffset: CGFloat = 0
    @EnvironmentObject var playerVM: PlayerViewModel
    @Binding var isExpanded: Bool
    @State private var isMusicPlaying = false
    
    var body: some View {
        ZStack {
            if isExpanded {
                expandedLayout
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                miniLayout
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
        .frame(maxHeight: isExpanded ? .infinity : 70)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}


extension PlayerMusicView {
    private var headerView: some View {
        HStack {
            
        }
    }
    
    private var expandedLayout: some View {
        VStack {
            Spacer()
            
            Image("image1")
                .resizable()
                .scaledToFill()
                .clipShape(.rect(cornerRadius: 10))
                .frame(width: 300, height: 300)
            
            Text("Vaina Loca - Osuna")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .padding(.top, 20)
            
            Text("Album - Aura")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Spacer()
            Spacer()
                
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    withAnimation { isExpanded = false }
                } label: {
                    Image(systemName: "arrow.down")
                        .foregroundStyle(.white)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation { isExpanded = false }
                } label: {
                    Image(systemName: "arrow.down")
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    private var miniLayout: some View {
        HStack(spacing: 12) {
            Image("image1")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text("La cancion")
                    .font(.headline).bold()
                    .foregroundColor(.white)
                Text("Bad Bunny, Jhay Cortez")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            HStack(spacing: 25) {
                Button {
                    withAnimation { isMusicPlaying.toggle() }
                } label: {
                    Image(systemName: isMusicPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .frame(width: 60, height: 60)
                        )
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "forward.end.fill")
                        .foregroundStyle(.white)
                        .font(.title2)
                }
            }
        }
        .padding(.horizontal)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring()) { isExpanded = true }
        }
    }
}

#Preview {
    PlayerMusicView(isExpanded: .constant(true))
}
