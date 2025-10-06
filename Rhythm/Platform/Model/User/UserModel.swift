//
//  UserModel.swift
//  Rhythm
//
//  Created by Apple on 4/10/25.
//


import Foundation

struct UserModel: Codable {
    let avatar_url: String?
    let city: String?
    let country: String?
    let description: String?
    let discogs_name: String?
    let first_name: String?
    let followers_count: Int?
    let followings_count: Int?
    let full_name: String?
    let id: Int?
    let kind: String?
    let created_at: String?
    let last_modified: String?
    let last_name: String?
    let permalink: String?
    let permalink_url: String?
    let plan: String?
    let playlist_count: Int?
    let public_favorites_count: Int?
    let reposts_count: Int?
    let track_count: Int?
    let uri: String?
    let username: String?
    let website: String?
    let website_title: String?
    
    enum CodingKeys: CodingKey {
        case avatar_url
        case city
        case country
        case description
        case discogs_name
        case first_name
        case followers_count
        case followings_count
        case full_name
        case id
        case kind
        case created_at
        case last_modified
        case last_name
        case permalink
        case permalink_url
        case plan
        case playlist_count
        case public_favorites_count
        case reposts_count
        case track_count
        case uri
        case username
        case website
        case website_title
    }
}
