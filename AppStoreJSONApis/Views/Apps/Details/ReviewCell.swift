//
//  ReviewCell.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 28.02.23.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    let titleLabel = UILabel(text: "Reviews Title", font: .boldSystemFont(ofSize: 18))
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
    let starsStackView: UIStackView = {
        var arrangedsubviews = [UIView]()
        (0..<5).forEach( { (_) in
            let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "star"))
            imageView.constrainHeight(constant: 24)
            imageView.constrainWidth(constant: 24)
            arrangedsubviews.append(imageView)
        })
        arrangedsubviews.append(UIView())
        
        let stackView = UIStackView(arrangedSubviews: arrangedsubviews)
        return stackView
    }()
    
    let bodyLabel = UILabel(text: "Review Body\nReview Body\nReview Body\n", font: .systemFont(ofSize: 18), numberOfLines: 5)
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel,
                authorLabel
            ],customSpacing: 8),
            starsStackView,
            bodyLabel
        ],spacing: 12)
        
        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        authorLabel.textAlignment = .right
        
        addSubview(stackView)
       // stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

 
