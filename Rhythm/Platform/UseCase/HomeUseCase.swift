//
//  Untitled.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation

class HomeUseCase {
    func fetchTrendingSections() async throws -> [CollectionSectionModel] {
        let client = APICollection()
        
//        return try await withCheckedThrowingContinuation { continuation in
//            client.execute { result in
//                switch result {
//                case .success(let value):
//                    continuation.resume(returning: value.collection)
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
        do {
                    let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<CollectionResponseModel, Error>) in
                        client.execute { result in
                            switch result {
                            case .success(let value):
                                continuation.resume(returning: value)
                            case .failure(let error):
                                continuation.resume(throwing: error)
                            }
                        }
                    }
                    return response.collection
                } catch let decoding as DecodingError {
                    // Log chi tiết để tìm đúng nguyên nhân
                    switch decoding {
                    case .keyNotFound(let key, let ctx):
                        print("❌ keyNotFound:", key.stringValue, "context:", ctx.debugDescription)
                    case .typeMismatch(let type, let ctx):
                        print("❌ typeMismatch:", type, "context:", ctx.debugDescription)
                    case .valueNotFound(let type, let ctx):
                        print("❌ valueNotFound:", type, "context:", ctx.debugDescription)
                    case .dataCorrupted(let ctx):
                        print("❌ dataCorrupted:", ctx.debugDescription)
                    @unknown default:
                        print("❌ unknown DecodingError:", decoding)
                    }
                    throw decoding
                } catch {
                    print("❌ API error:", error.localizedDescription)
                    throw error
                }
    }
}
