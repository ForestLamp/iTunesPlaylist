//
//  SearchResponse.swift
//  iTunesPlaylist
//
//  Created by Alex Ch. on 18.03.2022.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var artistName: String
    var trackName: String
    var artworkUrl60: String?
}
