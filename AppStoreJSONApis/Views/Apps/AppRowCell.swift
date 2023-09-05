//
//  AppRowCell.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 22.02.23.
//

import UIKit

class AppRowCell: UICollectionViewCell {
    
    var app: FeedResult! {
        didSet {
            companyLabel.text = app.name
            nameLabel.text = app.artistName
            imageView.sd_setImage(with: URL(string: app.artworkUrl100))
        }
    }
    
    
    let imageView = UIImageView(cornerRadius: 8)
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 20))
    let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    let getButton = UIButton(title: "GET")

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.layer.cornerRadius = 32 / 2
        
        let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangedSubviews: [nameLabel, companyLabel], spacing: 4), getButton])
        addSubview(stackView)
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.fillSuperview() 
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

    
    
}
