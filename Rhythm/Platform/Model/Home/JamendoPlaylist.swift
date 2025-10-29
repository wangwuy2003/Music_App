//
//  JamendoPlaylist.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import Foundation

struct JamendoPlaylist: Codable, Identifiable, Hashable {
    let id: String
    let name: String?
    let image: String?
    let userName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, image
        case userName = "user_name"
    }
}
