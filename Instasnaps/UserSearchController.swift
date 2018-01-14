//
//  UserSearchController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 14/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let cellId = "SearchedUserCellId"
    
    var users = [UserProfile]()
    var filteredUsers = [UserProfile]()
    
    lazy var userSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "enter username"
        searchBar.barTintColor = .gray
        searchBar.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(userSearchBar)
        userSearchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, topPadding: 0, leftPadding: 8, bottomPadding: 0, rightPadding: 8, width: 0, height: 0)
        
        fetchUserList()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filteredUsers = users
        }
        else{
            filteredUsers = users.filter({ (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            })
        }
        
        self.collectionView?.reloadData()
    }
    
    fileprivate func fetchUserList() {
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            userDictionary.forEach({ (key, value) in
                guard let userJSON = value as? [String: Any] else { return }
                let user = UserProfile(uid: key, dictionary: userJSON)
                self.users.append(user)
            })
            
            self.users.sort(by: { (user1, user2) -> Bool in
                return user1.username.lowercased().compare(user2.username.lowercased()) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
        }) { (error) in
            print("Error occured while fecthing user's list", error)
        }
    }
}
