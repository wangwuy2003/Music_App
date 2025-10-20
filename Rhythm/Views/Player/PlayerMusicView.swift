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
    
    // Track info
    @Binding var selectedMusic: TrackModel?
    @State private var currentSecond = 0.0
    @State private var totalSecond = 292.0
    private let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
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

// MARK: - Subviews
extension PlayerMusicView {
    private var expandedLayout: some View {
        VStack {
            Image("image1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(.rect(cornerRadius: 10))
                .frame(width: 300, height: 300)
                .padding(.top, 40)
            
            Text("Vaina Loca - Osuna")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(.top, 20)
            
            Text("Album - Aura")
                .font(.caption)
                .foregroundColor(.secondary)
            
            musicSlider
                .padding(.horizontal, 40)
            
            Spacer()
            
            musicControlButton
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
                
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Playlist Name")
        .navigationBarTitleDisplayMode(.inline)
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
                    Image(systemName: "heart")
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
    
    private var durationSlider: some View {
        ZStack{
            SwiftUISlider(
                thumbColor: .constant(.clear),
                    minTrackColor: .hex7A51E2,
                maxTrackColor: .hexF2F2F2,
                    value: $currentSecond,
                    maxValue: $totalSecond
                  )
            SwiftUISlider(
                thumbColor: .constant(.white),
                    minTrackColor: .hex7A51E2,
                maxTrackColor: .hexF2F2F2,
                    value: $currentSecond,
                    maxValue: $totalSecond
                  )
            .opacity(isExpanded ? 1 : 0)
        }
        .onReceive(timer) { _ in
                currentSecond += isMusicPlaying ? 1 : 0
        }
        .onChange(of: selectedMusic?.id) { newSelectedMusicId in
            guard let selectedMusic = self.selectedMusic else {return}
            withAnimation(.spring()){
                isExpanded.toggle()
                totalSecond = Double(selectedMusic.duration)
            }
            
        }
    }
    
    private var musicSlider: some View {
        VStack{
            durationSlider
            HStack{
                Text(setDurationInSecond(second: currentSecond))
                Spacer()
                Text(setDurationInSecond(second: totalSecond))
            }
            .scaleEffect(isExpanded ? 1 : 0)
            .font(.system(size: 16))
            .fontWeight(.semibold)
            .foregroundColor(.white.opacity(0.92))
        }
        .padding(.top, isExpanded ? 14 : -14)
        .padding(.horizontal, isExpanded ? 0 : -29)
    }
    
    private var musicControlButton: some View {
        VStack{
            HStack{
                Image(systemName: "shuffle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
                Spacer()
                Image(systemName: "backward.end.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
                Spacer()
                Circle()
                    .fill(Color.hex7A51E2)
                    .frame(width: 74, height: 74)
                    .overlay {
                        Image(systemName: isMusicPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .contentShape(Circle())
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isMusicPlaying.toggle()
                        }
                    }
                Spacer()
                Image(systemName: "forward.end.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
                Spacer()
                Image(systemName: "repeat")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22)
            }
            .foregroundColor(.white.opacity(0.92))
        }
        .padding(.top,14)
        .opacity(!isExpanded ? 0 : 1)
        .scaleEffect(!isExpanded ? 0 : 1)
    }
}

extension PlayerMusicView {
    func setDurationInSecond(second:Double) -> String{
        var secondValue = "00.00"
        let secondInt = Int(second)
        
        if secondInt < 10 { secondValue = "00:0\(secondInt)"}
        else if secondInt < 60 { secondValue = "00:\(secondInt)"}
        else {secondValue = "0\(Double(secondInt).asStringInMinute(style: .positional))"}
        
        return secondValue
    }
}

#Preview {
    PlayerMusicView(isExpanded: .constant(true), selectedMusic: .constant(nil))
}
