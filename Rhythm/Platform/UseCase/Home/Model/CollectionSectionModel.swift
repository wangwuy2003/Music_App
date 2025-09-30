
//
//  CollectionSectionModel.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation

struct CollectionSectionModel: Codable {
    let urn: String
    let query_urn: String
    let title: String
    let description: String?
    let tracking_feature_name: String?
    let last_updated: String?
    let style: String?
    let social_proof: String?
    let social_proof_users: String?
    let items:  CollectionPlaylistModel


}


struct CollectionPlaylistModel: Codable {
    let collection : [PlaylistModel]
}
