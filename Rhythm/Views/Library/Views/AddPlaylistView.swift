//
//  AddPlaylistModal.swift
//  Rhythm
//
//  Created by Apple on 11/10/25.
//

import SwiftUI
import SwiftfulRouting

struct AddPlaylistView: View {
    @Environment(\.router) var router
    
    @State private var textFieldText: String = ""
    @FocusState private var isTFFocused: Bool
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    dismissView()
                }
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.hex291F2A, .hex0F0E13]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Text(.localized("New Playlist"))
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .bold))
                    
                    textFieldSection
                    
                    buttonSection
                    
                }
            }
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: Color.hex1F1922, radius: 10, x: 0, y: 0)
            .frame(width: 265, height: 170)
            .offset(y: isTFFocused ? -80 : 0)
            .animation(.smooth, value: isTFFocused)
            .onDisappear {
                isTFFocused = false
            }
            
        }
    }
    
    private func dismissView() {
        isTFFocused = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            router.dismissModal()
        }
    }
}

// MARK: subviews
extension AddPlaylistView {
    private var textFieldSection: some View {
        VStack(spacing: 6) {
            TextField(.localized("Give your playlist a title"), text: $textFieldText)
                .focused($isTFFocused)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
            
            
            Divider()
        }
        .foregroundStyle(.hex8A9A9D)
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isTFFocused = true
            }
        }
    }
    
    private var buttonSection: some View {
        HStack(spacing: 60) {
            cancelButton
            createButton
        }
    }
    
    private var cancelButton: some View {
        Button {
            dismissView()
        } label: {
            Text(.localized("Cancel"))
                .foregroundStyle(.white)
                .font(.system(size: 12, weight: .bold))
                .padding(.vertical, 7)
                .padding(.horizontal, 15)
                .background(
                    Capsule().fill(Color.hex2C2F30)
                )
                .shadow(color: .white.opacity(0.15), radius: 10, x: 0, y: 0)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                        .blur(radius: 10)
                )
            
        }
    }
    
    private var createButton: some View {
        Button {
            //logic
            guard !textFieldText.trimmingCharacters(in: .whitespaces).isEmpty else {
                print("Yolo Playlist name is empty.")
                return
            }
            
            do {
                try StorageManager.shared.createPlaylistDirectory(name: textFieldText)
                
                dismissView()
            } catch let error as StorageError {
                switch error {
                case .directoryCreationFailed(let reason):
                    print("❌ Error: Could not create playlist. Reason: \(reason)")
                case .couldNotAccessDocumentsDirectory:
                    print("❌ Error: Could not access app's documents directory.")
                default:
                    print("❌ An unexpected storage error occurred: \(error)")
                }
                // Ở đây bạn có thể hiển thị một Alert cho người dùng
                
            } catch {
                print("❌ An unexpected error occurred: \(error.localizedDescription)")
            }
            
        } label: {
            Text(.localized("Create"))
                .foregroundStyle(.white)
                .font(.system(size: 12, weight: .bold))
                .padding(.vertical, 7)
                .padding(.horizontal, 15)
                .background(
                    Capsule().fill(Color.accentColor)
                )
                .shadow(color: .accentColor, radius: 10, x: 0, y: 0)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                        .blur(radius: 10)
                )
        }
    }
}

#Preview {
    AddPlaylistView()
}
