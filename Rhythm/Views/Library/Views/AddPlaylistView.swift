//
//  AddPlaylistModal.swift
//  Rhythm
//
//  Created by Apple on 11/10/25.
//

import SwiftUI
import SwiftfulRouting
import PhotosUI
import AVFoundation

struct AddPlaylistView: View {
    @Environment(\.router) var router
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var name: String = ""
    @State private var description: String = ""
    
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var showFileImporter = false
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer(minLength: 10)
                
                photoPickerSection
                
                TextField("Playlist Title", text: $name)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .focused($isNameFocused)
                    .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 40)
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 40)
            .navigationTitle("New Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        savePlaylist()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                isNameFocused = true
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotoItem, matching: .images)
            .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.image]) { result in
                switch result {
                case .success(let url):
                    if let data = try? Data(contentsOf: url) {
                        selectedImageData = data
                    }
                case .failure(let error):
                    print("❌ Lỗi chọn file: \(error)")
                }
            }
            
            .sheet(isPresented: $showCamera) {
                ImagePickerView(imageData: $selectedImageData)
            }
            
            .onChange(of: selectedPhotoItem) { _, newItem in
                if let newItem {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            }
        }
    }
    
    private var photoPickerSection: some View {
        ZStack {
            if let data = selectedImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 150, height: 150)
            }
            
            Menu {
                Button {
                    checkCameraPermission { granted in
                        if granted {
                            showCamera = true
                        } else {
                            print("❌ Người dùng chưa cấp quyền camera.")
                        }
                    }
                } label: {
                    Label(.localized("Take Camera"), systemImage: "camera")
                }

                Button {
                    showPhotoPicker = true
                } label: {
                    Label(.localized("Import from Photos"), systemImage: "photo")
                }

                Button {
                    showFileImporter = true
                } label: {
                    Label(.localized("Import from Files"), systemImage: "folder")
                }
            } label: {
                Image(systemName: "camera.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(16)
                    .background(Circle().fill(Color.red))
                    .menuStyle(.button)
                    .shadow(radius: 5)
            }
        }
    }
    
    private func savePlaylist() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        let trimmedDesc = description.trimmingCharacters(in: .whitespaces)
        
        let newPlaylist = Playlist(
            name: trimmedName,
            playlistDescription: trimmedDesc,
            imageData: selectedImageData
        )
        
        modelContext.insert(newPlaylist)
        
        do {
            try modelContext.save()
            print("✅ Playlist đã được lưu!")
            dismiss()
        } catch {
            print("❌ Lỗi lưu playlist: \(error.localizedDescription)")
        }
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }
}
