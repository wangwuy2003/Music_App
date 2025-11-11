//
//  RecommendedViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 10/11/25.
//


//import Foundation
//
//@MainActor
//final class RecommendedViewModel: ObservableObject {
//    @Published var recommendedTracks: [JamendoTrack] = []
//    
//    private let firestoreManager = FirestoreManager()
//    private let homeUseCase = UseCaseProvider.makeHomeUseCase()
//    
//    func loadRecommendations(for trackId: String) async {
//        firestoreManager.fetchSimilarTracks(for: trackId) { [weak self] ids in
//            Task {
//                do {
//                    // 🔹 Giả sử bạn đã có API lấy track theo ID (từ Jamendo)
//                    let allTracks = try await self?.homeUseCase.fetchTopTracks() ?? []
//                    self?.recommendedTracks = allTracks.filter { ids.contains($0.id) }
//                    print("🎧 Loaded \(self?.recommendedTracks.count ?? 0) recommended tracks")
//                } catch {
//                    print("❌ Failed to load recommended tracks:", error)
//                }
//            }
//        }
//    }
//}
