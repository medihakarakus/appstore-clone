//
//  TodayItem.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 03.03.23.
//

import UIKit

struct TodayItem {
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    //enum
    
    let cellType: CellType
    
    let apps: [FeedResult]
    
    enum CellType: String {
        case multiple, single
    }
    
}
