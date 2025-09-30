//
//  HomeViewModel.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    let homeUseCase = UseCaseProvider.makeHomeUseCase()
    
    @Published var trendingSections: [CollectionSectionModel]?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

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
}
