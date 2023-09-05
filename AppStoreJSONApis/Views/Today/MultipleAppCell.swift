//
//  MultipleAppCell.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 04.03.23.
//

import UIKit

class MultipleAppCell: UICollectionViewCell{
    var app: FeedResult! {
        didSet {
            companyLabel.text = app.artistName
            imageView.sd_setImage(with: URL(string: app.artworkUrl100))
            nameLabel.text = app.name
        }
    }
    
    let imageView = UIImageView(cornerRadius: 8)
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 20))
    let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    let getButton = UIButton(title: "GET")
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.2)
        return view
    }()

    
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
        
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -6, right: 0), size: .init(width: 0, height: 0.5))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
