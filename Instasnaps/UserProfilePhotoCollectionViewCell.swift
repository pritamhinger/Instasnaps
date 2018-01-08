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
            fetchImage(fromUrl: imageUrl)
        }
    }
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
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
    
    fileprivate func fetchImage(fromUrl urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error occured while fetching image", error)
                return
            }
            
            guard let imageData = data else { return }
            print(imageData)
            guard let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                print("Setting image")
                self.postImageView.image = image
            }
            
        }.resume()
    }
}
