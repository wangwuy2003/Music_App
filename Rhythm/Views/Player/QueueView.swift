//
//  QueueView.swift
//  Rhythm
//
//  Created by Apple on 1/11/25.
//

import SwiftUI
import SwiftfulRouting

struct QueueView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        RouterView { _ in
            VStack(alignment: .leading, spacing: 10) {
                List {
                    ForEach(Array(playerVM.currentQueue.enumerated()), id: \.offset) { index, track in
                        TrackRowQueue(track: track)
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                playerVM.startPlayback(from: playerVM.currentQueue, startingAt: index)
                            }
                    }
                    .onMove(perform: moveItem)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .background(themeManager.backgroundColor)
            .navigationTitle(.localized("Now Playing Queue"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(themeManager.textColor)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        playerVM.currentQueue.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    QueueView()
}
