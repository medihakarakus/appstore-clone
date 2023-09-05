//
//  AppFullScreenHeaderCell.swift
//  AppStoreJSONApis
//
//  Created by Mediha Karakuş on 02.03.23.
//

import UIKit
class AppFullScreenHeaderCell: UITableViewCell {
    
    let todayCell = TodayCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(todayCell)
        todayCell.fillSuperview()
        
//        contentView.addSubview(closeButton)
//        closeButton.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 44, left: 0, bottom: 0, right: 12), size: .init(width:  80, height: 38))
//
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
