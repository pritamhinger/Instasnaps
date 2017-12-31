//
//  UserProfileHeader.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 31/12/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionViewCell {
    
    var user: UserProfile?{
        didSet{
            fetchProfileImage()
            usernameLabel.text = user?.username
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 80 / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel : UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "10\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "Posts", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel : UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "Followers", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel : UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "Following", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let editProfileButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(editProfileButton)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 12, leftPadding: 12, bottomPadding: 0, rightPadding: 0, width: 80, height: 80)
        
        setupBottomBarControls()
        setUpStatControls()
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, topPadding: 4, leftPadding: 12, bottomPadding: 0, rightPadding: 12, width: 0, height: 0)
        
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, topPadding: 2, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func fetchProfileImage() {
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
    
    fileprivate func setupBottomBarControls() {
        let bottomPanelStackView = UIStackView(arrangedSubviews: [gridButton,listButton, bookmarkButton])
        bottomPanelStackView.axis = .horizontal
        bottomPanelStackView.distribution = .fillEqually
        addSubview(bottomPanelStackView)
        
        bottomPanelStackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 50)
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        addSubview(topDividerView)
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        addSubview(bottomDividerView)
        
        topDividerView.anchor(top: bottomPanelStackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: bottomPanelStackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0.5)
    }
    
    func setUpStatControls() {
        let statControlsStackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        statControlsStackView.axis = .horizontal
        statControlsStackView.distribution = .fillEqually
        
        addSubview(statControlsStackView)
        statControlsStackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, topPadding: 12, leftPadding: 12, bottomPadding: 0, rightPadding: 12, width: 0, height: 50)
    }
}
