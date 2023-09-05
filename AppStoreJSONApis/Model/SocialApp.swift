//
//  AppHeader.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 23.02.23.
//

import UIKit

struct SocialApp: Decodable, Hashable {
    let id: String
    let name: String
    let tagline: String
    let imageUrl: String
}
