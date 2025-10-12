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
    
    @Published var trendingSections: [CollectionSectionModel]?
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
}
