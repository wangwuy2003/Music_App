//
//  FirestoreManager.swift
//  Rhythm
//
//  Created by MacMini A6 on 10/11/25.
//

import Foundation
import FirebaseFirestore

final class FirestoreManager {
    static let shared = FirestoreManager()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: Log user action (play, like, complete)
    func logListeningEvent(uid: String, trackId: String, type: String) {
        let data: [String: Any] = [
            "uid": uid,
            "track_id": trackId,
            "type": type,
            "ts": Timestamp(date: Date())
        ]
        
        db.collection("listening_events").addDocument(data: data) { error in
            if let error = error {
                print("❌ Error logging event: \(error)")
            } else {
                print("✅ Logged \(type) for track \(trackId)")
            }
        }
    }
    
    // MARK: Get similar songs from item_item_sim
    func fetchSimilarTracks(for trackId: String, completion: @escaping ([String]) -> Void) {
        db.collection("item_item_sim").document(trackId).getDocument { snapshot, error in
            if let error = error {
                print("❌ Error fetching similar tracks: \(error)")
                completion([])
                return
            }
            
            guard let data = snapshot?.data(),
                  let neighbors = data["neighbors"] as? [[String: Any]] else {
                print("⚠️ No similar tracks found for \(trackId)")
                completion([])
                return
            }
            
            let ids = neighbors.compactMap { $0["id"] as? String }
            completion(ids)
        }
    }
}
