//
//  UserProfileHeader.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 31/12/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var user: UserProfile?{
        didSet{
            fetchProfileImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 12, leftPadding: 12, bottomPadding: 0, rightPadding: 0, width: 80, height: 80)
        profileImageView.backgroundColor = .red
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        
        guard let url = URL(string: profileImageUrl) else { return }

        URLSession.shared.dataTask(with: url, completionHandler: { (data, reponse, error) in
            if let error = error {
                print("Failed to fetch data from url", error)
                return
            }

            guard let data = data else { return }
            guard let profileImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.profileImageView.image = profileImage
            }
        }).resume()
    }
}
