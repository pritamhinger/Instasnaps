//
//  PhotoHeaderCell.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 01/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit

class PhotoHeaderCell: UICollectionViewCell {
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) not implemented")
    }
}
