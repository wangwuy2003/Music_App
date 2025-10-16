//
//  StorageManager.swift
//  Rhythm
//
//  Created by Apple on 14/10/25.
//

import Foundation

class StorageManager {
    
    // MARK: - Properties
    static let shared = StorageManager()
    private let fileManager = FileManager.default
    private let playlistsFolderName = "Playlists"
    
    private init() {
        createPlaylistsRootDirectory()
    }
    
    // MARK: - Get all playlists
    func fetchAllPlaylists() throws -> [PlaylistItem] {
        guard let playlitsURL = getPlaylistsRootURL() else {
            throw StorageError.fetchingFailed(reason: "failed")
        }
    }
    
    // MARK: - Create playlist
    func createPlaylistDirectory(name: String) throws {
        guard let playlistsURL = getPlaylistsRootURL() else {
            throw StorageError.couldNotAccessDocumentsDirectory
        }
        
        let newPlaylistURL = playlistsURL.appendingPathComponent(name)
        
        do {
            try fileManager.createDirectory(at: newPlaylistURL, withIntermediateDirectories: true, attributes: nil)
            print("✅ Successfully created directory at path: \(newPlaylistURL.path)")
        } catch {
            throw StorageError.directoryCreationFailed(reason: error.localizedDescription)
        }
    }
    
    // MARK: - Rename playlist
    func renamePlaylistDirectory(from oldName: String, to newName: String) throws {
        guard let playlistsURL = getPlaylistsRootURL() else {
            throw StorageError.couldNotAccessDocumentsDirectory
        }
        
        let sourceURL = playlistsURL.appendingPathComponent(oldName)
        let destinationURL = playlistsURL.appendingPathComponent(newName)
        
        guard fileManager.fileExists(atPath: sourceURL.path) else {
            throw StorageError.directoryNotFound
        }
        
        do {
            try fileManager.moveItem(at: sourceURL, to: destinationURL)
            print("✅ Successfully renamed '\(oldName)' to '\(newName)'")
        } catch {
            throw StorageError.directoryRenameFailed(reason: error.localizedDescription)
        }
    }
    
    // MARK: - Delete playlist
    func deletetPlaylistDirectory(name: String) throws {
        guard let playlistsURL = getPlaylistsRootURL() else {
            throw StorageError.couldNotAccessDocumentsDirectory
        }
        
        let playlistURL = playlistsURL.appendingPathComponent(name)
        
        // check folder exist
        guard fileManager.fileExists(atPath: playlistURL.path) else {
            throw StorageError.directoryNotFound
        }
        
        do {
            try fileManager.removeItem(at: playlistURL)
            print("✅ Successfully deleted directory: \(name)")
        } catch {
            throw StorageError.directoryDeletionFailed(reason: error.localizedDescription)
        }
    }
    
    // Get URL directory Documents
    private func getDocumentsDirectoryURL() -> URL? {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    // Get URL root "Playlists"
    private func getPlaylistsRootURL() -> URL? {
        guard let documentsURL = getDocumentsDirectoryURL() else {
            return nil
        }
        
        return documentsURL.appendingPathComponent(playlistsFolderName)
    }
    
    private func createPlaylistsRootDirectory() {
        guard let playlistsURL = getPlaylistsRootURL() else {
            return
        }
        
        if !fileManager.fileExists(atPath: playlistsURL.path) {
            do {
                try fileManager.createDirectory(at: playlistsURL, withIntermediateDirectories: true, attributes: nil)
                print("✅ Successfully created root 'Playlists' directory.")
            } catch {
                print("❌ Error creating root 'Playlists' directory: \(error.localizedDescription)")
            }
        }
    }
}

enum StorageError: Error {
    case directoryCreationFailed(reason: String)
    case directoryDeletionFailed(reason: String)
    case directoryRenameFailed(reason: String)
    case directoryNotFound
    case couldNotAccessDocumentsDirectory
    case fetchingFailed(reason: String)
}
