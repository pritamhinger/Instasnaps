//
//  UserSearchCell.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 14/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    let imageViewSide: CGFloat = 50
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        
        userProfileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, topPadding: 0, leftPadding: 8, bottomPadding: 0, rightPadding: 0, width: 50, height: 50)
        userProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        userProfileImageView.layer.cornerRadius = imageViewSide / 2
        userProfileImageView.layer.masksToBounds = true
        
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 8, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
        
        separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) is not implemented")
    }
}
