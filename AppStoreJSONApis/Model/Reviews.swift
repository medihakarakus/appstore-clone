//
//  Reviews.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 01.03.23.
//

import UIKit

struct Reviews: Decodable {
    let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
    let entry: [Entry]
}

struct Entry: Decodable {
    let title: Label
    let content: Label
    let author: Author
    let rating: Label
    
    private enum CodingKeys: String, CodingKey {
        case title
        case content
        case author
        case rating = "im:rating"
    }
}


struct Author: Decodable {
    let name: Label
}
struct Label: Decodable {
    let label: String
}

