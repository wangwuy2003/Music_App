//
//  FavouritesView.swift
//  Rhythm
//
//  Created by MacMini A6 on 31/10/25.
//

import SwiftUI
import SwiftData
import SwiftfulRouting
import SDWebImageSwiftUI

struct FavouritesView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.router) var router
    @EnvironmentObject var playerVM: PlayerViewModel
    @Query private var favourites: [FavouriteTrack]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            if favourites.isEmpty {
                Text(.localized("No favourite songs yet."))
                    .foregroundStyle(.primary.opacity(0.7))
                    .padding()
            } else {
                List {
                    PlaylistHeaderFavouriteView(
                        onPlay: {
                            playAll()
                        },
                        onShuffle: {
                            playShuffled()
                        }
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding(.bottom, 20)
                    
                    ForEach(Array(favourites.enumerated()), id: \.element.jamendoID) { index, track in
                        TrackRowView(track: track.toJamendoTrack(), isInFavouritesView: true)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                let tracks = favourites.map { $0.toJamendoTrack() }
                                playerVM.startPlayback(from: tracks, startingAt: index)
                            }
                    }
                    .onDelete(perform: deleteFavourite)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .animation(.easeInOut(duration: 0.3), value: favourites)
            }
        }
        .contentShape(Rectangle())
        .enableSwipeBack()
        .navigationTitle(.localized(""))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.dismissScreen()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: Helpers
    
    private func playAll() {
        let tracks = favourites.map { $0.toJamendoTrack() }
        playerVM.startPlayback(from: tracks, startingAt: 0)
    }
    
    private func playShuffled() {
        let shuffled = favourites.shuffled().map { $0.toJamendoTrack() }
        playerVM.startPlayback(from: shuffled, startingAt: 0)
    }
    
    private func deleteFavourite(at offsets: IndexSet) {
        for index in offsets {
            let track = favourites[index]
            modelContext.delete(track)
        }
        try? modelContext.save()
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark
            ? [.hex291F2A, .hex0F0E13]
            : [Color.white, Color(.systemGray6)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct PlaylistHeaderFavouriteView: View {
    let onPlay: (() -> Void)?
    let onShuffle: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [.purple.opacity(0.8), .black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 200, height: 200)
                    .shadow(color: .primary.opacity(0.4), radius: 10)
                Image(systemName: "heart.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 4) {
                Text(.localized("Favourites Song"))
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.primary)
            }
            
            
            HStack(spacing: 25) {
                Button {
                    print("▶️ Phát playlist")
                    onPlay?()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                        Text(.localized("Play"))
                            .fontWeight(.semibold)
                    }
                    .frame(width: 140, height: 45)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
                
                Button {
                    print("🔀 Xáo trộn playlist")
                    onShuffle?()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "shuffle")
                        Text(.localized("Random"))
                            .fontWeight(.semibold)
                    }
                    .frame(width: 140, height: 45)
                    .background(.gray.opacity(0.3))
                    .foregroundStyle(.accent)
                    .clipShape(Capsule())
                }
            }
            .padding(.top, 8)
            .buttonStyle(.borderless)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
