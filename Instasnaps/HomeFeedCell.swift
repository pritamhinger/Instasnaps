//
//  HomeFeedCell.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 11/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit

class HomeFeedCell: UICollectionViewCell {
    
    var post: Post? {
        didSet{
            guard let imageUrl = post?.postImageUrl else { return }
            photoImageView.loadImage(withUrlString: imageUrl)
        }
    }
    
    let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
