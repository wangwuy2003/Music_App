//
//  EditPlaylistView.swift
//  Rhythm
//
//  Created by MacMini A6 on 13/11/25.
//

import SwiftUI
import SwiftData
import PhotosUI
import AVFoundation
import SwiftfulRouting

struct EditPlaylistView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Environment(\.router) var router
    
    var playlist: Playlist
    
    // temp copy for editing
    @State private var draftPlaylist: PlaylistDraft
    
    // Playlist load from SwiftData to display tracks
    @State private var loadedPlaylist: Playlist?
    @State private var localTracks: [SavedTrack] = []
    @State private var originalIDs: [String] = []

    // temp photo
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var showFileImporter = false
    
    @State private var selectedTracks: Set<String> = []
    @State private var gradient = LinearGradient.randomDark()
    
    init(playlist: Playlist) {
        self.playlist = playlist
        _draftPlaylist = State(initialValue: PlaylistDraft(from: playlist))
    }
    
    var body: some View {
        ZStack {
            gradient
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        photoPickerSection
                        
                        TextField("Playlist Name", text: $draftPlaylist.name)
                            .font(.title3.bold())
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        TextField("Description", text: $draftPlaylist.description, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                            .padding(.horizontal)
                            .textFieldStyle(.plain)
                        
                        Divider().padding(.horizontal)
                        
                        // MARK: Tracks List
                        trackListSection
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 80)
                }
                .scrollDismissesKeyboard(.immediately)
            }
        }
        
        .navigationTitle("Edit playlist")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button { handleDismiss() } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button { saveChanges() } label: {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .bottomBar) {
                SpacerView()
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    router.showAlert(
                        .alert,
                        title: "Delete \(selectedTracks.count) song\(selectedTracks.count > 1 ? "s" : "")",
                        subtitle: "Are you sure you want to delete them from this playlist?"
                    ) {
                        Button("Cancel", role: .cancel) {}
                        Button("Delete", role: .destructive) { deleteSelectedTracks() }
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 10, weight: .semibold))
                        .padding()
                        .background(Circle().fill(selectedTracks.isEmpty ? Color.gray.opacity(0.4) : Color.accentColor))
                        .foregroundColor(.white)
                        .shadow(radius: selectedTracks.isEmpty ? 0 : 5)
                        .padding()
                }
                .disabled(selectedTracks.isEmpty)
                .animation(.easeInOut, value: selectedTracks.isEmpty)
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotoItem, matching: .images)
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.image]) { result in
            switch result {
            case .success(let url):
                if let data = try? Data(contentsOf: url) {
                    draftPlaylist.imageData = data
                }
            case .failure(let error):
                print("❌ File import error: \(error.localizedDescription)")
            }
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    draftPlaylist.imageData = data
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            ImagePickerView(imageData: $draftPlaylist.imageData)
        }
        .onAppear {
            loadPlaylist()
        }
        .onChange(of: playlist.tracks) { _, _ in
            loadPlaylist()
        }
        .onAppear {
            let toolbarAppearance = UIToolbarAppearance()
            toolbarAppearance.configureWithTransparentBackground()
            toolbarAppearance.backgroundColor = .clear
            toolbarAppearance.shadowColor = .clear
            
            UIToolbar.appearance().standardAppearance = toolbarAppearance
            UIToolbar.appearance().scrollEdgeAppearance = toolbarAppearance
        }

    }
}

// MARK: Subviews
extension EditPlaylistView {
    private var trackListSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Tracks")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                Spacer()
            }
            .padding(.horizontal)
            
            if !localTracks.isEmpty {
                TrackReorderList(
                    tracks: $localTracks,
                    selectedTracks: $selectedTracks
                )
            } else {
                Text("No tracks in this playlist yet.")
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.top, 4)
            }
        }
    }
}

// MARK: Functions
extension EditPlaylistView {
    // MARK: - Load playlist
    private func loadPlaylist() {
        Task {
            do {
                let targetID = playlist.id
                let descriptor = FetchDescriptor<Playlist>(
                    predicate: #Predicate { $0.id == targetID }
                )
                loadedPlaylist = try modelContext.fetch(descriptor).first
                
                if let loaded = loadedPlaylist {
                    // Lấy thứ tự đã lưu (nếu có)
                    if var savedOrder = UserDefaults.standard.array(forKey: "playlist_order_\(loaded.id)") as? [String] {
                        // 🔹 Thêm những track mới chưa có trong savedOrder
                        let newTrackIDs = loaded.tracks.map { $0.jamendoID }
                        for id in newTrackIDs where !savedOrder.contains(id) {
                            savedOrder.append(id)
                        }
                        
                        // 🔹 Cập nhật localTracks theo thứ tự mới
                        localTracks = savedOrder.compactMap { id in
                            loaded.tracks.first(where: { $0.jamendoID == id })
                        }

                        // 🔹 Ghi đè lại order mới
                        UserDefaults.standard.set(savedOrder, forKey: "playlist_order_\(loaded.id)")
                    } else {
                        localTracks = loaded.tracks
                        UserDefaults.standard.set(localTracks.map { $0.jamendoID }, forKey: "playlist_order_\(loaded.id)")
                    }

                    originalIDs = localTracks.map { $0.jamendoID }
                }
                print("✅ Loaded playlist: \(loadedPlaylist?.name ?? "nil") with \(loadedPlaylist?.tracks.count ?? 0) tracks")
            } catch {
                print("❌ Error fetching playlist: \(error)")
            }
        }
    }
    
    // MARK: - Photo Section
    private var photoPickerSection: some View {
        ZStack {
            if let data = draftPlaylist.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 180)
                    .overlay(
                        Image(systemName: "music.note.list")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.5))
                    )
            }
            
            Menu {
                Button {
                    checkCameraPermission { granted in
                        if granted { showCamera = true }
                    }
                } label: {
                    Label(.localized("Take Camera"), systemImage: "camera")
                }
                
                Button {
                    checkPhotoPermission { granted in
                        if granted { showPhotoPicker = true }
                    }
                } label: {
                    Label(.localized("Import from Photos"), systemImage: "photo")
                }
                
                Button { showFileImporter = true } label: {
                    Label(.localized("Import from Files"), systemImage: "folder")
                }
            } label: {
                Image(systemName: "camera.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(18)
                    .background(Circle().fill(Color.accent))
                    .shadow(radius: 5)
            }
        }
    }
    
    // MARK: - Save Changes
    private func saveChanges() {
        playlist.name = draftPlaylist.name
        playlist.playlistDescription = draftPlaylist.description
        playlist.imageData = draftPlaylist.imageData
        playlist.tracks = localTracks
        
        // 🔹 Lưu thứ tự hiện tại để khôi phục lần sau
        UserDefaults.standard.set(localTracks.map { $0.jamendoID },
                                  forKey: "playlist_order_\(playlist.id)")
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("❌ Error saving changes: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Selected Tracks
    private func deleteSelectedTracks() {
        localTracks.removeAll { selectedTracks.contains($0.jamendoID) }
        selectedTracks.removeAll()
    }
    
    // MARK: - Handle Dismiss
    private func handleDismiss() {
        let currentIDs = localTracks.map { $0.jamendoID }

        let isModified =
            draftPlaylist.name != playlist.name ||
            draftPlaylist.description != playlist.playlistDescription ||
            draftPlaylist.imageData != playlist.imageData ||
            originalIDs != currentIDs

        if isModified {
            router.showAlert(
                .alert,
                title: "Discard changes?",
                subtitle: "You have unsaved changes to this playlist. Are you sure you want to discard them?"
            ) {
                Button("Cancel", role: .cancel) {}
                Button("Discard", role: .destructive) { dismiss() }
            }
        } else {
            dismiss()
        }
    }
}

// MARK: Permissions
extension EditPlaylistView {
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        default: completion(false)
        }
    }

    private func checkPhotoPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited: completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        default: completion(false)
        }
    }
}

struct SpacerView: View {
    var body: some View {
        Color.clear.frame(maxWidth: .infinity)
    }
}
