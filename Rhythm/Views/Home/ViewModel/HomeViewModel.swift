//
//  HomeViewModel.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation
import Combine
import SwiftfulRouting

@MainActor
class HomeViewModel: ObservableObject {
    let router: AnyRouter
    let homeUseCase = UseCaseProvider.makeHomeUseCase()
    
    @Published var trendingSections: [CollectionSectionModel]?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: AnyRouter) {
        self.router = router
    }

    func fetchData() {
        isLoading = true
        errorMessage = nil
        
        homeUseCase.fetchTrendingSections()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("API Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] sections in
                self?.trendingSections = sections
                print(sections)
            }
            .store(in: &cancellables)
    }
    
    
    func openPlaylist(playlistId: Int) {
        router.showScreen(.push) { _ in
            PlaylistView(playlistId: playlistId)
        }
    }
}
