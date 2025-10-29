//
//  JamendoResponse.swift
//  Rhythm
//
//  Created by Apple on 28/10/25.
//

import Foundation

struct JamendoResponse<T: Codable>: Codable {
    let headers: ResponseHeaders
    let results: [T]
}

struct ResponseHeaders: Codable {
    let status: String
    let resultsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case status
        case resultsCount = "results_count"
    }
}
