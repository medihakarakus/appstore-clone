//
//  ReviewCell.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 28.02.23.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {
    
    let reviewsController = ReviewsController()
  
    override init(frame: CGRect) {
        super.init(frame: frame) 
        addSubview(reviewsController.view)
        reviewsController.view.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
