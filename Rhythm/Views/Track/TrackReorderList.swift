//
//  TrackReorderList.swift
//  Rhythm
//
//  Created by MacMini A6 on 13/11/25.
//
import SwiftUI
import SwiftData

struct TrackReorderList: View {
    @Environment(\.modelContext) var modelContext
    @Binding var tracks: [SavedTrack]
    @Binding var selectedTracks: Set<String>
    @State private var dragItem: SavedTrack?

    var body: some View {
        ForEach(tracks, id: \.jamendoID) { track in
            HStack {
                // MARK: - Circle (always visible)
                Image(systemName: selectedTracks.contains(track.jamendoID)
                      ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(selectedTracks.contains(track.jamendoID)
                                     ? .accentColor : .gray)

                // MARK: - Track Info
                HStack {
                    if let url = track.imageURL, let imageURL = URL(string: url) {
                        AsyncImage(url: imageURL) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    } else {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 50, height: 50)
                            .overlay(Image(systemName: "music.note")
                                     .foregroundColor(.white.opacity(0.5)))
                    }

                    VStack(alignment: .leading) {
                        Text(track.name)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        Text(track.artistName ?? "Unknown")
                            .font(.subheadline)
                            .foregroundStyle(.primary.opacity(0.6))
                            .lineLimit(1)
                    }
                }
                .padding(.leading, 4)

                Spacer()

                // MARK: - Reorder handle
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
                    .onDrag {
                        dragItem = track
                        return NSItemProvider(object: track.jamendoID as NSString)
                    }
                    .onDrop(of: [.text], delegate: TrackDropDelegate(
                        item: track,
                        tracks: $tracks,
                        dragItem: $dragItem
                    ))
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .contentShape(Rectangle()) 
            .onTapGesture {
                toggleSelection(for: track)
            }
        }
        .onChange(of: tracks) { oldValue, newValue in
            try? modelContext.save()
        }
    }

    private func toggleSelection(for track: SavedTrack) {
        if selectedTracks.contains(track.jamendoID) {
            selectedTracks.remove(track.jamendoID)
        } else {
            selectedTracks.insert(track.jamendoID)
        }
    }
}

// MARK: - Drop Delegate
struct TrackDropDelegate: DropDelegate {
    let item: SavedTrack
    @Binding var tracks: [SavedTrack]
    @Binding var dragItem: SavedTrack?

    func performDrop(info: DropInfo) -> Bool { true }

    func dropEntered(info: DropInfo) {
        guard let dragItem = dragItem,
              dragItem.jamendoID != item.jamendoID,
              let fromIndex = tracks.firstIndex(where: { $0.jamendoID == dragItem.jamendoID }),
              let toIndex = tracks.firstIndex(where: { $0.jamendoID == item.jamendoID })
        else { return }

        withAnimation {
            tracks.move(fromOffsets: IndexSet(integer: fromIndex),
                        toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}
