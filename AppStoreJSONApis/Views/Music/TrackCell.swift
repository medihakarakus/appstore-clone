//
//  TrackCell.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 08.03.23.
//

import UIKit

class TrackCell: UICollectionViewCell {
    
    let imageView = UIImageView(cornerRadius: 16)
    let namaLabel = UILabel(text: "Track name", font: .boldSystemFont(ofSize: 18))
    let subtitleLabel = UILabel(text: "Subtitle label", font: .systemFont(ofSize: 12), numberOfLines: 2)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = UIImage(named: "garden")
        imageView.constrainWidth(constant: 80)
        
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [namaLabel, subtitleLabel], spacing: 4)
        ], customSpacing: 16)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        stackView.alignment = .center
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
