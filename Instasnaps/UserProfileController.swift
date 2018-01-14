//
//  UserProfileController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 31/12/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserProfileController: UICollectionViewController {
    
    let headerReusableIdentifier = "headerId"
    let cellReusableIdentifier = "cellId"
    
    var user: UserProfile?
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReusableIdentifier)
        collectionView?.register(UserProfilePhotoCollectionViewCell.self, forCellWithReuseIdentifier: cellReusableIdentifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot.value ?? "Value is nil or empty")
            guard let userProfileDictionary = snapshot.value as? [String: Any] else {return}
            
            self.user = UserProfile(dictionary: userProfileDictionary)
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
            self.fetchOrderedUserPosts()
            
        }, withCancel: {(error) in
            print("Error occred while reading user profile")
        })
    }
    
    fileprivate func fetchOrderedUserPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        userPostRef.queryOrdered(byChild: "createdOn").observe(.childAdded, with: { (snapshot) in
            guard let postDictionary = snapshot.value as? [String: Any] else { return }
            
            guard let user = self.user else { return }
            let post = Post(user: user, dictionary: postDictionary)
            self.posts.insert(post, at: 0)
            
            self.collectionView?.reloadData()
        }) { (error) in
            print("Error occured while loading the user's posts", error)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReusableIdentifier, for: indexPath) as! UserProfilePhotoCollectionViewCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/3
        return CGSize(width: width, height: width)
    }
    
    @objc func handleLogout() {
        let logoutActionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        logoutActionController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
                try Auth.auth().signOut()
                let loginController = LoginController()
                let loginNavigationController = UINavigationController(rootViewController: loginController)
                self.present(loginNavigationController, animated: true, completion: nil)
            } catch let signOutError{
                print("Error occured while signing out", signOutError)
            }
        }))
        
        logoutActionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(logoutActionController, animated: true, completion: nil)
    }
}

extension UserProfileController: UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReusableIdentifier, for: indexPath) as! UserProfileHeader
        headerCell.user = user
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}
