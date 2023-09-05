//
//  SearchResultCell.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 14.02.23.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    var appResult: Result! {
        didSet {
            nameLabel.text = appResult.trackName
            categoryLabel.text = appResult.primaryGenreName
            ratingsLabel.text = "\(appResult.averageUserRating ?? 0)"
            
            let url = URL(string: appResult.artworkUrl100)
            appIconimageView.sd_setImage(with: url)
            screenshot1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![0]))
            if appResult.screenshotUrls!.count > 1 {
                screenshot2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![1]))
            }
            
            if appResult.screenshotUrls!.count > 2 {
                screenshot3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls![2]))
            }
        }
    }
    
    let appIconimageView: UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 64).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 64).isActive = true
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "APP NAME"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "PHOTO & VIDEO"
        return label
    }()
    
    let ratingsLabel: UILabel = {
        let label = UILabel()
        label.text = "9.26M"
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton()
        button.setTitle("GET", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    lazy var screenshot1ImageView = self.createScreenshotImageview()
    lazy var screenshot2ImageView = self.createScreenshotImageview()
    lazy var screenshot3ImageView = self.createScreenshotImageview()
    
    func createScreenshotImageview() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let infoTopStackView = UIStackView(arrangedSubviews: [
            appIconimageView,
            VerticalStackView(arrangedSubviews: [nameLabel, categoryLabel, ratingsLabel]),
            getButton
        ])
        infoTopStackView.spacing = 12
        infoTopStackView.alignment = .center
        
        let screenshotStackView = UIStackView(arrangedSubviews: [screenshot1ImageView, screenshot2ImageView, screenshot3ImageView])
        screenshotStackView.spacing = 12
        screenshotStackView.distribution = .fillEqually
        
        let overallStackView = VerticalStackView(arrangedSubviews: [infoTopStackView, screenshotStackView], spacing: 16)

        addSubview(overallStackView)
        
        overallStackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
