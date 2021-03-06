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
    let gridViewCellIdentifier = "gridViewCellId"
    let listViewCellIdentifier = "listViewCellId"
    
    var user: UserProfile?
    var posts = [Post]()
    var userId: String?
    var isGridView = true
    var didFinishedPaging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReusableIdentifier)
        collectionView?.register(UserProfilePhotoCollectionViewCell.self, forCellWithReuseIdentifier: gridViewCellIdentifier)
        collectionView?.register(HomeFeedCell.self, forCellWithReuseIdentifier: listViewCellIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
            self.fetchUserPostsOnPerPageBasis()
        }
    }
    
    fileprivate func fetchUserPostsOnPerPageBasis(){
        guard let uid = self.user?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        //var query = userPostRef.queryOrderedByKey()
        var query = userPostRef.queryOrdered(byChild: "createdOn")
        
        if posts.count > 0 {
            guard let startingValue = posts.last?.creationDate.timeIntervalSince1970 else { return }
            query = query.queryEnding(atValue: startingValue)
        }
        
        query.queryLimited(toLast: 3).observeSingleEvent(of: .value, with: { (snapshot) in

            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            guard let user = self.user else { return }
            
            allObjects.reverse()
            
            if allObjects.count < 3{
                self.didFinishedPaging = true
            }
            
            if self.posts.count > 0 && allObjects.count > 0{
                allObjects.removeFirst()
            }
            
            allObjects.forEach({ (snapshot) in
                guard let postDictionary = snapshot.value as? [String : Any] else { return }
                var post = Post(user: user, dictionary: postDictionary)
                post.postId = snapshot.key
                self.posts.append(post)
            })
            
            self.collectionView?.reloadData()
        }) { (error) in
            print("Error occured while getting ")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == self.posts.count - 1 && !didFinishedPaging {
            fetchUserPostsOnPerPageBasis()
        }
        
        if isGridView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridViewCellIdentifier, for: indexPath) as! UserProfilePhotoCollectionViewCell
            cell.post = posts[indexPath.item]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listViewCellIdentifier, for: indexPath) as! HomeFeedCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView{
            let width = (view.frame.width - 2)/3
            return CGSize(width: width, height: width)
        }
        else{
            var height: CGFloat = 8 + 40 + 8
            height += view.frame.width
            height += 50
            height += 60
            return CGSize(width: view.frame.width, height: height)
        }
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

extension UserProfileController: UICollectionViewDelegateFlowLayout, UserProfileLayoutDelegate{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReusableIdentifier, for: indexPath) as! UserProfileHeader
        headerCell.user = user
        headerCell.delegate = self
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
    
    func didChangeToGridView() {
        isGridView = true
        collectionView?.reloadData()
    }
    
    func didChangeToListView() {
        isGridView = false
        collectionView?.reloadData()
    }
}
