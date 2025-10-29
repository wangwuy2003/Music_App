//
//  HomeViewModel.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation
import SwiftfulRouting

@MainActor
class HomeViewModel: ObservableObject {
    let router: AnyRouter
    let homeUseCase = UseCaseProvider.makeHomeUseCase()
    
    @Published var trendingSections: [FeedModal] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    init(router: AnyRouter) {
        self.router = router
    }

    func fetchData() async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            let sections = try await homeUseCase.fetchTrendingSections()
            trendingSections = sections
            print("✅ Yolo Loaded \(sections.count) sections")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Yolo API Error:", error.localizedDescription)
        }
    }
    
    func openPlaylist(playlistId: Int) {
        router.showScreen(.push) { _ in
            PlaylistView(playlistId: playlistId)
        }
    }
    
    func openItem(_ feed: FeedModal) {
        // API Jamendo dùng 'joinid' (String), nhưng PlaylistView của bạn
        // dùng 'playlistId' (Int). Chúng ta cần chuyển đổi nó.
        guard let id = Int(feed.joinid) else {
            print("❌ Yolo: Invalid joinid, cannot navigate: \(feed.joinid)")
            errorMessage = "Invalid item ID."
            return
        }
        
        // Quyết định mở màn hình nào dựa trên 'feed.type'
        if feed.type == "playlist" {
            router.showScreen(.push) { _ in
                PlaylistView(playlistId: id)
            }
        } else if feed.type == "album" {
            // Bạn có thể thêm điều hướng đến AlbumDetailView ở đây
            print("ℹ️ Yolo: Navigate to Album ID: \(id)")
            // router.showScreen(.push) { _ in AlbumDetailView(albumId: id) }
        } else {
            print("ℹ️ Yolo: Tapped item of type '\(feed.type)', no navigation set.")
        }
    }
}
