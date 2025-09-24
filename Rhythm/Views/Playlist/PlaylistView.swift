//
//  PlaylistView.swift
//  Rhythm
//
//  Created by Apple on 23/9/25.
//

import SwiftUI
import SwiftfulRouting

struct PlaylistView: View {
    @Environment(\.router) var router
    
    let tracks: [Track] = Track.sample
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            List {
                ForEach(tracks) { track in
                    TrackRowView(track: track)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            router.showScreen(.push) { _ in                           MusicView()
                                    .navigationBarBackButtonHidden()
                            }
                        }
                }
            }
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(.localized("Playlist Name"))
    }
}

#Preview {
    PlaylistView()
}
