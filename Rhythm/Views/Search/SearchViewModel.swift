//
//  SearchViewModel.swift
//  Rhythm
//
//  Created by MacMini A6 on 3/11/25.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var tracks: [JamendoTrack] = []
    @Published var albums: [JamendoAlbum] = []
    @Published var playlists: [JamendoPlaylistDetail] = []
    @Published var artists: [JamendoArtist] = []
}
