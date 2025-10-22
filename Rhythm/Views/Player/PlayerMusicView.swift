//
//  MusicView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting
import LNPopupUI
import LoremIpsum
import SwiftUIIntrospect

extension View {
    @ViewBuilder
    func hiddenThumbIfPossible() -> some View {
#if compiler(>=6.2)
        if #available(iOS 26.0, *) {
            self.sliderThumbVisibility(.hidden)
        } else {
            self
        }
#else
        self
#endif
    }
}

@MainActor
struct RandomTitleSong : Equatable, Identifiable {
    var id: Int
    let imageName: String = "coverImage"
    var title: String = LoremIpsum.title
    var subtitle: String = LoremIpsum.words(withNumber: 5)
}

struct PlayerMusicView: View {
    @Environment(\.router) var router
    @EnvironmentObject var playerVM: PlayerViewModel
    
    @State var playbackProgress: Float = Float.random(in: 0..<1)
    @State var volume: Float = Float.random(in: 0..<1)
    @State var isPlaying: Bool = true
    
    @Environment(\.popupBarPlacement) var popupBarPlacement
    
    let song: RandomTitleSong
    
    init(song: RandomTitleSong) {
        self.song = song
    }
    
    var body: some View {
        GeometryReader { geometry in
            return VStack {
                Image(song.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: .black.opacity(0.5), radius: 10)
                    .padding([.leading, .trailing], 20)
                    .padding([.top], geometry.size.height * 60 / 896.0)
                    .popupTransitionTarget()
                VStack(spacing: geometry.size.height * 30.0 / 896.0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.system(size: 20, weight: .bold))
                            Text(song.subtitle)
                                .font(.system(size: 20, weight: .regular))
                        }
                        .lineLimit(1)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               alignment: .topLeading)
                        Button {} label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title)
                        }
                    }
                    Slider(value: $playbackProgress)
                        .padding([.bottom], geometry.size.height * 30.0 / 896.0)
                        .hiddenThumbIfPossible()
                    HStack {
                        Button {} label: {
                            Image(systemName: "backward.fill")
                        }.frame(minWidth: 0, maxWidth: .infinity)
                        
                        Button {
                            isPlaying.toggle()
                        } label: {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        }
                        .font(.system(size: 50, weight: .bold))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        
                        Button {} label: {
                            Image(systemName: "forward.fill")
                        }.frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .font(.system(size: 30, weight: .regular))
                    .padding([.bottom], geometry.size.height * 20.0 / 896.0)
                    HStack {
                        Image(systemName: "speaker.fill")
                        Slider(value: $volume)
                        Image(systemName: "speaker.wave.2.fill")
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                    HStack {
                        Button {} label: {
                            Image(systemName: "shuffle")
                        }.frame(minWidth: 0, maxWidth: .infinity)
                        
                        Button {} label: {
                            Image(systemName: "airplayaudio")
                        }.frame(minWidth: 0, maxWidth: .infinity)
                        
                        Button {} label: {
                            Image(systemName: "repeat")
                        }.frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .font(.body)
                }
                .layoutPriority(1)
                .padding(geometry.size.height * 40.0 / 896.0)
            }
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .top)
            .background {
                ZStack {
                    Image(song.imageName)
                        .resizable()
                    Color(uiColor: .systemBackground)
                        .opacity(0.55)
                }.compositingGroup().blur(radius: 90, opaque: true)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .popupTitle(song.title)
        .popupImage(Image(song.imageName).resizable())
        .popupProgress(playbackProgress)
        .popupBarItems {
            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }.padding(10)
            
            if popupBarPlacement != .inline {
                Button {
                    print("Next")
                } label: {
                    Image(systemName: "forward.fill")
                }.padding(10)
            }
        }
    }
}
