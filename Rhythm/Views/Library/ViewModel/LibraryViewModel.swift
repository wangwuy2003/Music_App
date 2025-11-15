//
//  LibraryViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 31/10/25.
//

import Foundation
import SwiftfulRouting
import SwiftData
import SwiftUI
import AVFoundation

@MainActor
class LibraryViewModel: ObservableObject {
    let router: AnyRouter
    @Published var playlists: [Playlist] = []
    @Published var favourites: [FavouriteTrack] = []
    
    private var modelContext: ModelContext?
    
    init(router: AnyRouter) {
        self.router = router
    }
    
    func attachModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - Playlist Actions
    
    func deletePlaylist(_ playlist: Playlist) {
        guard let modelContext else { return }
        print("🗑️ Deleting playlist:", playlist.name)
        modelContext.delete(playlist)
    }
    
    func confirmDeletePlaylist(_ playlist: Playlist) {
        router.showAlert(
            .alert,
            title: "Delete \(playlist.name)?",
            subtitle: "This action cannot be undone."
        ) {
            Button("Cancel", role: .cancel) { }
            
            Button(.localized("Delete"), role: .destructive) { [weak self] in
                self?.deletePlaylist(playlist)
            }
        }
    }
    
    // MARK: - Delete track
    func confirmDeleteTrack(_ track: SavedTrack, from playlist: Playlist) {
        router.showAlert(
            .alert,
            title: "Remove “\(track.name)”?",
            subtitle: "This track will be deleted from \(playlist.name)."
        ) {
            Button("Cancel", role: .cancel) { }
            
            Button("Delete", role: .destructive) { [weak self] in
                self?.deleteTrack(track, from: playlist)
            }
        }
    }
    
    private func deleteTrack(_ track: SavedTrack, from playlist: Playlist) {
        guard let modelContext else { return }
        
        if let index = playlist.tracks.firstIndex(where: { $0.jamendoID == track.jamendoID }) {
            playlist.tracks.remove(at: index)
            try? modelContext.save()
            print("🗑️ Deleted track: \(track.name) from \(playlist.name)")
        }
    }
    
    
}

extension LibraryViewModel {
    //    func isFavourite(_ track: JamendoTrack) -> Bool {
    //        let descriptor = FetchDescriptor<FavouriteTrack>(
    //            predicate: #Predicate { $0.jamendoID == track.id }
    //        )
    //        if let modelContext,
    //           let results = try? modelContext.fetch(descriptor) {
    //            return !results.isEmpty
    //        }
    //        return false
    //    }
    //
    //    func addToFavourites(_ track: JamendoTrack) {
    //        guard let modelContext else { return }
    //
    //        if isFavourite(track) { return }
    //
    //        let favourite = FavouriteTrack(jamendoTrack: track)
    //        modelContext.insert(favourite)
    //        try? modelContext.save()
    //        print("❤️ Added to favourites:", track.name)
    //    }
    
    func deleteTrackFavourites(_ track: JamendoTrack) {
        guard let modelContext else { return }
        
        let descriptor = FetchDescriptor<FavouriteTrack>(
            predicate: #Predicate { $0.jamendoID == track.id }
        )
        if let results = try? modelContext.fetch(descriptor),
           let first = results.first {
            modelContext.delete(first)
            try? modelContext.save()
            print("💔 Removed from favourites:", track.name)
        }
    }
    
    // MARK: - Delete Favourite Track
    func confirmDeleteFavourite(_ track: JamendoTrack) {
        router.showAlert(
            .alert,
            title: "Delete “\(track.name)”?",
            subtitle: "This will remove it from your favourites."
        ) {
            Button("Cancel", role: .cancel) { }
            
            Button(.localized("Delete"), role: .destructive) { [weak self] in
                withAnimation(.easeInOut(duration: 0.3)) {
                    self?.deleteTrackFavourites(track)
                    NotificationCenter.default.post(name: .favouritesDidChange, object: nil)
                }
            }
        }
    }
    
    
}

// MARK: Local song
extension LibraryViewModel {
    func ensureMyUploadsPlaylistExists() -> Playlist {
        guard let modelContext else { fatalError("ModelContext not attached") }
        
        let fetch = FetchDescriptor<Playlist>(
            predicate: #Predicate { $0.name == "My Uploads" }
        )
        
        if let existing = try? modelContext.fetch(fetch).first {
            return existing
        } else {
            let uploads = Playlist(name: "My Uploads", playlistDescription: "Your personal uploaded songs")
            modelContext.insert(uploads)
            try? modelContext.save()
            return uploads
        }
    }
    
    func handleUploadAudio(from url: URL) {
        guard let modelContext else { return }

        // 🔒 Cho phép truy cập security scoped resource (khi lấy từ Files)
        let isAccessGranted = url.startAccessingSecurityScopedResource()
        defer {
            if isAccessGranted {
                url.stopAccessingSecurityScopedResource()
            }
        }

        let fileManager = FileManager.default
        let uploadsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Uploads", isDirectory: true)

        // ✅ Tạo thư mục Uploads nếu chưa có
        if !fileManager.fileExists(atPath: uploadsDir.path) {
            do {
                try fileManager.createDirectory(at: uploadsDir, withIntermediateDirectories: true)
                print("📁 Created Uploads folder:", uploadsDir.path)
            } catch {
                print("❌ Failed to create folder:", error.localizedDescription)
                return
            }
        }

        let destinationURL = uploadsDir.appendingPathComponent(url.lastPathComponent)

        // 🚫 Nếu file đã tồn tại → bỏ qua (không copy, không thêm playlist)
        if fileManager.fileExists(atPath: destinationURL.path) {
            print("⚠️ File already exists, skipping:", destinationURL.lastPathComponent)
            return
        }

        // ✅ Copy file vào thư mục app sandbox
        do {
            try fileManager.copyItem(at: url, to: destinationURL)
            print("✅ Copied file to:", destinationURL.path)
        } catch {
            print("❌ Copy failed:", error.localizedDescription)
            return
        }

        // ✅ Lấy thông tin file audio
        let asset = AVURLAsset(url: destinationURL)
        let duration = CMTimeGetSeconds(asset.duration)
        if duration.isNaN {
            print("⚠️ Invalid duration:", destinationURL.lastPathComponent)
        }

        let track = JamendoTrack(
            id: UUID().uuidString,
            name: destinationURL.lastPathComponent,
            albumId: nil,
            duration: Int(duration),
            artistName: "Unknown Artist",
            albumImage: nil,
            image: nil,
            audio: destinationURL.lastPathComponent,
            audioDownload: nil
        )

        let uploadsPlaylist = ensureMyUploadsPlaylistExists()

        // 🚫 Nếu track đã có trong playlist → bỏ qua
        if uploadsPlaylist.tracks.contains(where: { $0.name == track.name }) {
            print("⚠️ Skipped duplicate track in playlist:", track.name)
            return
        }

        // ✅ Thêm track mới vào playlist
        let savedTrack = SavedTrack(jamendoTrack: track, playlist: uploadsPlaylist)
        uploadsPlaylist.tracks.append(savedTrack)
        try? modelContext.save()

        print("✅ Added \(track.name) (\(Int(duration))s) to My Uploads")
    }

    func confirmDeleteLocalTrack(_ track: SavedTrack, from playlist: Playlist) {
        router.showAlert(
            .alert,
            title: "Delete “\(track.name)”?",
            subtitle: "This song will be permanently removed from My Uploads."
        ) {
            Button("Cancel", role: .cancel) { }

            Button("Delete", role: .destructive) { [weak self] in
                withAnimation(.easeInOut(duration: 0.25)) {
                    self?.deleteLocalTrack(track, from: playlist)
                }
            }
        }
    }

    func deleteLocalTrack(_ track: SavedTrack, from playlist: Playlist) {
        guard let modelContext else { return }

        // ✅ Luôn trỏ vào thư mục Uploads trong sandbox
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let uploadsDir = documentsURL.appendingPathComponent("Uploads", isDirectory: true)
        
        if let fileName = track.audioURL {
            let fileURL = uploadsDir.appendingPathComponent(fileName)
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: fileURL.path) {
                do {
                    try fileManager.removeItem(at: fileURL)
                    print("🗑️ Deleted local file:", fileURL.path)
                } catch {
                    print("❌ Failed to delete local file:", error.localizedDescription)
                }
            } else {
                print("⚠️ File not found when deleting:", fileURL.path)
            }
        }

        if let index = playlist.tracks.firstIndex(where: { $0.jamendoID == track.jamendoID }) {
            playlist.tracks.remove(at: index)
        }

        modelContext.delete(track)
        try? modelContext.save()
        print("✅ Deleted track object: \(track.name)")
    }
}
