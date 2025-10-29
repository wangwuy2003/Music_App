//
//  HydratedPlaylist.swift
//  Rhythm
//
//  Created by MacMini A6 on 29/10/25.
//


import Foundation

struct HydratedPlaylist: Identifiable, Hashable {
    let id: String
    let playlistId: String
    let name: String
    let coverImage: String?
}
