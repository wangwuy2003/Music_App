//
//  MultiFileImporter.swift
//  Rhythm
//
//  Created by Apple on 15/11/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct MultiFileImporter: UIViewControllerRepresentable {
    var allowedContentTypes: [UTType]
    var onPicked: ([URL]) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedContentTypes)
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPicked: onPicked)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPicked: ([URL]) -> Void

        init(onPicked: @escaping ([URL]) -> Void) {
            self.onPicked = onPicked
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            var collectedURLs: [URL] = []
            
            for url in urls {
                let isAccessGranted = url.startAccessingSecurityScopedResource()
                defer {
                    if isAccessGranted {
                        url.stopAccessingSecurityScopedResource()
                    }
                }

                let ext = url.pathExtension.lowercased()
                
                if ext == "m4p" {
                    print("🚫 Skipping DRM-protected file:", url.lastPathComponent)
                    continue
                }
                
                if ["mp3", "m4a", "wav", "aac", "flac"].contains(ext) {
                    collectedURLs.append(url)
                } else {
                    print("⚠️ Unsupported file type:", url.lastPathComponent)
                }
            }
            
            onPicked(collectedURLs)
        }
    }
}
