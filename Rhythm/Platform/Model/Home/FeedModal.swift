//
//  FeedModal.swift
//  Rhythm
//
//  Created by Apple on 28/10/25.
//

import Foundation

struct FeedResponse: Codable {
    let headers: ResponseHeaders
    let results: [FeedModal]
}

struct FeedModal: Codable, Identifiable, Hashable {
    
    let id: String
    let type: String
    let joinid: String
    let title: [String: String]?
    
    var name: String {
        title?["en"] ?? "Playlist"
    }
    
}
