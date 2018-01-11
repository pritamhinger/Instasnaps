//
//  UserProfilePhotoCollectionViewCell.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 08/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit

class UserProfilePhotoCollectionViewCell: UICollectionViewCell {
    
    var post: Post? {
        didSet{
            guard let imageUrl = post?.postImageUrl else { return }
            postImageView.loadImage(withUrlString: imageUrl)
        }
    }
    
    let postImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
