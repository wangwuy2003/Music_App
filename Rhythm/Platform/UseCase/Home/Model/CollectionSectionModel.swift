
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

// MARK: - Mocks

extension CollectionSectionModel {
    static func mock(
        urn: String,
        title: String,
        playlists: [PlaylistModel]
    ) -> CollectionSectionModel {
        .init(
            urn: urn,
            query_urn: "query:\(urn)",
            title: title,
            description: "Mô tả \(title)",
            tracking_feature_name: nil,
            last_updated: "2025-09-29T12:00:00Z",
            style: "horizontal",
            social_proof: nil,
            social_proof_users: nil,
            items: .init(collection: playlists)
        )
    }

    static let mockSections: [CollectionSectionModel] = [
        .mock(
            urn: "urn:section:trending",
            title: "Trending Now",
            playlists: [
                .init(id: 1, title: "Hot Hits", artworkURL: "https://picsum.photos/300/300?1", trackCount: 25, likesCount: 1200, duration: 5400),
                .init(id: 2, title: "Fresh Pop", artworkURL: "https://picsum.photos/300/300?2", trackCount: 18, likesCount: 860, duration: 4200),
                .init(id: 3, title: "Indie Vibes", artworkURL: "https://picsum.photos/300/300?3", trackCount: 30, likesCount: 640, duration: 7200)
            ]
        ),
        .mock(
            urn: "urn:section:recommended",
            title: "Recommended For You",
            playlists: [
                .init(id: 4, title: "Chill Beats", artworkURL: "https://picsum.photos/300/300?4", trackCount: 22, likesCount: 910, duration: 5100),
                .init(id: 5, title: "Workout Mix", artworkURL: "https://picsum.photos/300/300?5", trackCount: 20, likesCount: 750, duration: 4800)
            ]
        )
    ]
}
