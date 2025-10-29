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

struct FeedModal: Codable, Identifiable {
    
    let id: String
    let type: String
    let joinid: String
    
    let title: [String: String]
    
   
    let images: FeedImages
    
    var mainTitle: String {
        return title["en"] ?? title.first?.value ?? "Nội dung nổi bật"
    }
    
    var coverImageURL: URL? {
        let urlString = images.size996_350 ?? images.size600_211 ?? ""
        return URL(string: urlString)
    }
}

struct FeedImages: Codable {
    
    let size996_350: String?
    let size600_211: String?
    let size470_165: String?
    
    enum CodingKeys: String, CodingKey {
        case size996_350 = "size996_350"
        case size600_211 = "size600_211"
        case size470_165 = "size470_165"
    }
}
