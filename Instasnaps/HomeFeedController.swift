//
//  HomeFeedController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 11/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase

class HomeFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "homeFeedCellIdentifier"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.dataSource = self
        
        setUpNavigationBarControls()
        fetchUserPosts()
    }
    
    fileprivate func setUpNavigationBarControls(){
        let label = UILabel()
        label.font = UIFont(name: "Zapfino", size: 20)
        label.text = "InstaSnaps"
        navigationItem.titleView = label
    }
    
    fileprivate func fetchUserPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionay = snapshot.value as? [String: Any] else{ return }
            let user = UserProfile(dictionary: userDictionay)
            let userPostRef = Database.database().reference().child("posts").child(uid)
            
            userPostRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let allPostsDictionary = snapshot.value as? [String: Any] else { return }
                allPostsDictionary.forEach({ (key, value) in
                    
                    guard let postJSON = value as? [String: Any] else { return }
                    
                    let post = Post(user: user, dictionary: postJSON)
                    
                    self.posts.append(post)
                })
                
                self.collectionView?.reloadData()
            }) { (error) in
                print("Error occured fetching user's post from Database")
            }
        }) { (error) in
            print("Error occured while fetching user", error)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeFeedCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 8 + 40 + 8
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
}
