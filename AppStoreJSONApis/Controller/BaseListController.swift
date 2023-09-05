//
//  BaseListController.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 21.02.23.
//

import UIKit

class BaseListController: UICollectionViewController {
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
