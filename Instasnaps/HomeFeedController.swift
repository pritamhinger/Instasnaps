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

        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeedNotification), name: SharePhotoController.updateFeedNotificatioName, object: nil)
        let refeshControl = UIRefreshControl()
        refeshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refeshControl
        
        collectionView?.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.dataSource = self
        
        setUpNavigationBarControls()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchUserPosts()
        fetchFollowingUsersPosts()
    }
    
    @objc fileprivate func handleUpdateFeedNotification(){
        handleRefresh()
    }
    
    @objc fileprivate func handleRefresh() {
        print("Refreshing")
        posts.removeAll()
        fetchAllPosts()
        //collectionView?.refreshControl?.endRefreshing()
    }
    
    fileprivate func setUpNavigationBarControls(){
        let label = UILabel()
        label.font = UIFont(name: "Zapfino", size: 20)
        label.text = "InstaSnaps"
        navigationItem.titleView = label
    }
    
    fileprivate func fetchFollowingUsersPosts() {
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(currentLoggedInUser).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach({ (key, value) in
                
                Database.fetchUserWithUID(uid: key, onCompletionHandler: { (user) in
                    self.fetchPostsForUser(user: user)
                })
            })
        }) { (error) in
            print("Error occured while fetching list of users being followed")
        }
    }
    
    fileprivate func fetchUserPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsForUser(user: user)
        }
    }
    
    fileprivate func fetchPostsForUser(user: UserProfile) {
        let userPostRef = Database.database().reference().child("posts").child(user.uid)
        
        userPostRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView?.refreshControl?.endRefreshing()
            guard let allPostsDictionary = snapshot.value as? [String: Any] else { return }
            allPostsDictionary.forEach({ (key, value) in
                
                guard let postJSON = value as? [String: Any] else { return }
                
                let post = Post(user: user, dictionary: postJSON)
                self.posts.append(post)
            })
            
            self.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate.compare(post2.creationDate) == .orderedDescending
            })
            
            self.collectionView?.reloadData()
        }) { (error) in
            print("Error occured fetching user's post from Database")
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
