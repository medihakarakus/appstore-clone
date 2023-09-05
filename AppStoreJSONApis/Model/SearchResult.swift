//
//  SearchResult.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 16.02.23.
//

import Foundation


struct SearchResult:Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result:Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
    var screenshotUrls: [String]?
    let artworkUrl100: String // app icon
    var formattedPrice: String?
    var description: String?
    var releaseNotes: String?
    var artistName: String?
    var collectionName: String?
    
}
