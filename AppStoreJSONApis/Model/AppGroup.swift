//
//  AppGroup.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 22.02.23.
//

import UIKit

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable, Hashable {
    let id, name, artistName, artworkUrl100: String
}
